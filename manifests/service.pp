class cups::service inherits cups {

  #
  validate_bool($cups::manage_docker_service)
  validate_bool($cups::manage_service)
  validate_bool($cups::service_enable)

  validate_re($cups::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${cups::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $cups::manage_docker_service)
  {
    if($cups::manage_service)
    {
      service { $cups::params::service_name:
        ensure => $cups::service_ensure,
        enable => $cups::service_enable,
      }
    }
  }
}
