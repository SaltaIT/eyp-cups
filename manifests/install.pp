class cups::install inherits cups {

  if($cups::manage_package)
  {
    package { $cups::params::package_name:
      ensure => $cups::package_ensure,
    }
  }

}
