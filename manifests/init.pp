# randrust
#
# Main class, includes all other classes.
#
class randrust {
  contain randrust::install
  contain randrust::config
  contain randrust::service


  Class['::randrust::install']
  -> Class['::randrust::config']
  ~> Class['::randrust::service']
}
