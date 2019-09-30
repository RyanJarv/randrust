# randrust
[![Build Status](https://travis-ci.org/RyanJarv/randrust.svg?branch=master)](https://travis-ci.org/RyanJarv/randrust)

#### Table of Contents

1. [Description](#description)
2. [Usage - Configuration options and additional functionality](#usage)
    * [Kubernetes with Helm](#kubernetes-with-helm)
    * [From Package](#from-package)
    * [Puppet](#puppet)
    * [Docker Compose](#docker-compose)
    * [DockerHub](#dockerhub)
3. [Nagios Check](#nagios-check)
4. [Limitations - Or why you shouldn't use in prod](#limitations)
5. [Development - Guide for contributing to the module](#development)
5. [Contributors/References](#contributors/references)

## Description

A rust web app that returns a random base64 encoded string of a given length.

## Usage

### Kubernetes with Helm

This assumes you have a kubernetes cluster setup with helm installed.

On OSx you can use the Edge install of [docker-for-mac](https://docs.docker.com/v17.12/docker-for-mac/install/#download-docker-for-mac) to setup Kubernetes by enabling it under the running Docker Icon -> Preferences -> Kubernetes.

For setting up helm on Kubernetes see the [helm install guide](https://helm.sh/docs/using_helm/#installing-helm).

After this is setup you can deploy by cloning this repo and running the deploy script.
```
git clone https://github.com/RyanJarv/randrust.git
cd randrust
 ./scripts/helm_deploy.sh
 ```

This uses [Let's Encrypt](https://letsencrypt.org/docs/client-options/) for setting up SSL but without changes like using a valid domain name it will generate a self signed cert.

### From Package
* Ubuntu 18.04
* Ubuntu 16.04
* Debian 9

```
curl -s https://packagecloud.io/install/repositories/jarv/test/script.deb.sh | sudo bash
apt install randrust
```

This listens on the port configured in /etc/default/randrust. By default it is `31531`.

### Puppet

Puppet supports the same systems as the package install.

See the [puppet-randrust](https://github.com/RyanJarv/puppet-randrust) repo for more info.

### From source locally

```
# Install rust
curl https://sh.rustup.rs -sSf | sh

# Clone and build
git clone https://github.com/RyanJarv/randrust.git
cd randrust
./scripts/build.sh

# Run and test
./target/release/randrust 3413 &
curl localhost:3413/key/5
```

### Docker Compose

This uses nginx as a frontend with a self signed SSL cert.

See the [reference docs](https://docs.docker.com/compose/install/) for installing Docker Compose.

```
git clone https://github.com/RyanJarv/randrust.git
cd randrust
docker-compose up
curl -k https://localhost/key/4
```

NOTE: This uses the hardcoded self signed test key at ssl/test.* currently. This should be updated if it's used for anything but testing.

### Dockerhub

```
docker run -p 127.0.0.1:8080:80 ryanjarv/randrust &
curl http://localhost:8080/key/5
```

## Nagios Check

This repo includes the `check_randrust.py` script you can use as a check in nagios.

### Install

Dependencies in `requirements.txt` need to be installed.

```
python3 -m venv .venv
. .venv/bin/activate
./check_randrust.py 
```

NOTE: Currently there is no option to disable SSL verification, so using it on self signed cert's will not work.

### Usage

```
usage: check_randrust.py [-h] [-wt RANGE] [-ct RANGE] -u URL [-wl RANGE]
                         [-cl RANGE] [-v]

Randrust Nagios check.

optional arguments:
  -h, --help            show this help message and exit
  -wt RANGE, --twarning RANGE
                        return warning if response time is greater out of
                        RANGE in seconds
  -ct RANGE, --tcritical RANGE
                        return critical if response time is longer out of
                        RANGE in seconds)
  -u URL, --url URL     URL to check
  -wl RANGE, --wlength RANGE
                        return warning if decoded string length is outside of
                        RANGE
  -cl RANGE, --clength RANGE
                        return critical if decoded string length is outside of
                        RANGE
  -v, --verbose         increase output verbosity (use up to 3 times)
```

### Example

```
./check_randrust.py --url http://localhost:8000/key/4 --twarning .1 --tcritical .2 --clength 4:4
RANDRUST OK - Decoded returned string length is 4 | length=4;1:;4:4;0 rtime=0.00957179069519043;0.1;0.2;0
```


## Limitations

These should be fixed soon, but until then this should not be used in production.

* Docker Compose uses a hardcoded test key currently. This should be updated if used for anything but testing.
* Has anxiety, may panic.
* Unconfigurable bind interface.
* This is my first coding in Rust... so whatever goes along with that.

## Development

### Kubernete's/Helm

See [Usage](#Usage) for setup info.

To lint and test deployment's you can use `helm_lint.sh` and `helm_deploy.sh`.
```
./scripts/helm_lint.sh
./scripts/helm_deploy.sh
```

### Helm CI

At one point this repo was set up with the Circle CI [helm orb](https://circleci.com/orbs/registry/orb/circleci/helm) for testing in AWS EKS, however it takes a long time to run and isn't cheap without some changes. May look into some other options at somepoint here.

I tried a few other way's like [Kubernetes in Docker](https://github.com/kubernetes-sigs/kind.git) but ran into issues with setting up the ingress route (if you end up trying this check out [this post](https://banzaicloud.com/blog/kind-ingress/), had some inconsistent luck there). 

Right now though I just have Travis CI [setup](https://travis-ci.org/RyanJarv/randrust) to lint the scripts and chart's while it's building the rust package.

### Rust/Deb CI

Travis CI [build's](https://travis-ci.org/RyanJarv/randrust) the rust app and debian package with [cargo-deb](https://github.com/mmstick/cargo-deb) and deploy's to [crates.io](https://crates.io/crates/randrust).

Right now there isn't any testing on the Rust app, may change soon though.

## Contributors/References

In cases where other open source packages, repos or work helped with writing the source for this package I list what it is along with the original license.

* [Icon](https://htmlpreview.github.io/?https://github.com/RyanJarv/randrust/blob/master/helm/randrust/icon.svg) used for the helm package was created by ibrandify (https://thenounproject.com/ibrandify/)
  * [CCPL](https://creativecommons.org/licenses/by/3.0/us/legalcode).
* Ubuntu's 18.04 [rsyslogd package](https://launchpad.net/ubuntu/bionic/amd64/rsyslog/8.16.0-1ubuntu9) was used as reference for control and init scripts, though some of it is simplified.
  * [GPL-3](https://git.launchpad.net/ubuntu/+source/rsyslog/tree/COPYING?h=ubuntu/xenial-updates)
* Helm's scaffolding from the `helm create` command.
  * [Apache-2](https://github.com/helm/helm/blob/master/LICENSE)

The rest is written by [Ryan Gerstenkorn](https://github.com/RyanJarv) and licensed under [BSD-2](https://opensource.org/licenses/BSD-2-Clause). 
