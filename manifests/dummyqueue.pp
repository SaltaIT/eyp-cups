# lpadmin -p nowhere -E -v file:/dev/null
# lpstat -p nowhere -o nowhere | grep enabled
# printer nowhere is idle.  enabled since Wed 23 Nov 2016 16:34:05 GMT
#
#
# lpoptions -d nowhere
#
# check default queue
# lpoptions  | grep -Eo "printer-info=[^ ]*" | cut -f2 -d= | grep ...
#
define cups::dummyqueue(
                          $queuename=$name,
                          $default = true
                        ) {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  exec { "create dummy queue ${queuename}":
    command => "lpadmin -p ${queuename} -E -v file:/dev/null",
    unless  => "lpstat -p ${queuename} -o ${queuename} | grep enabled",
  }

  if($default)
  {
    exec { 'set default queue':
      command => "lpoptions -d ${queuename}",
      unless  => "lpoptions  | grep -Eo \"printer-info=[^ ]*\" | cut -f2 -d= | grep ${queuename}",
      require => Exec["create dummy queue ${queuename}"],
    }
  }
}
