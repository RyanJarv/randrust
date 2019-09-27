#!/usr/bin/env python
"""Randrust Nagios check."""

import nagiosplugin
import base64
import argparse
import subprocess
import logging
import urllib.request
import urllib.parse
import time

_log = logging.getLogger()

class Randrust(nagiosplugin.Resource):
    """Domain model: response body.

    Determines the round trip time for the and the length of the decoded
    base64 string in the body for `url`.
    The `url` is a url string of the endpoint to check.
    """

    def __init__(self, url):
        self.url = url

    def request(self, url):
        _log.info('making request to %s', self.url)
        start = time.time()
        req = urllib.request.urlopen(self.url)
        body = req.read()
        end = time.time()
        req.close()
        rtime = end - start
        _log.info('request took %s', rtime)
        return body, rtime

    def decoded_length(self, body):
        return len(base64.b64decode(body))

    def probe(self):
        body, rtime = self.request(self.url)
        yield nagiosplugin.Metric('rtime', rtime, min=0, context='rtime')
        length = self.decoded_length(body)
        yield nagiosplugin.Metric('length', length, min=0, context='length')
                                    
class ResponseSummary(nagiosplugin.Summary):
    """Status line conveying response time information."""
    def ok(self, results):
        return 'response time is {}'.format(str(results.metric))

class LengthSummary(nagiosplugin.Summary):
    """Status line conveying decoded base64 length.

    The response body is expected to only contain a base64 string which
    is checked if the wlength of clength CLI arguments are set.
    """
    def ok(self, results):
        return 'Decoded returned string {}'.format(str(results.by_name['length']))


@nagiosplugin.guarded
def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('-wt', '--twarning', metavar='RANGE', default='0.5',
                      help='return warning if response time is greater out of RANGE in seconds')
    argp.add_argument('-ct', '--tcritical', metavar='RANGE', default='1',
                      help='return critical if response time is longer out of RANGE in seconds)')
    argp.add_argument('-u', '--url', metavar='URL', required=True,
                      help="URL to check")
    argp.add_argument('-wl', '--wlength', metavar='RANGE', default='1:',
                      help="return warning if decoded string length is outside of RANGE")
    argp.add_argument('-cl', '--clength', metavar='RANGE', default='1:',
                      help="return critical if decoded string length is outside of RANGE")
    argp.add_argument('-v', '--verbose', action='count', default=0,
                      help='increase output verbosity (use up to 3 times)')
    args = argp.parse_args()
    check = nagiosplugin.Check(
        Randrust(args.url),
        nagiosplugin.ScalarContext('rtime', args.twarning, args.tcritical),
        nagiosplugin.ScalarContext('length', args.wlength, args.clength),
        ResponseSummary(),
        LengthSummary(),
        )

    check.main(verbose=args.verbose)

if __name__ == '__main__':
    main()
