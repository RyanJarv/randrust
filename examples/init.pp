node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'randrust':
    require => Notify['enduser-before'],
    before  => Notify['enduser-after'],
  }

}
