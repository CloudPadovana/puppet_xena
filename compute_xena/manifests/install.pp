class compute_xena::install inherits compute_xena::params {

#include compute_xena::params

$cloud_role = $compute_xena::cloud_role          

### Repository settings (remove old rpm and install new one)
  
  define removepackage {
    exec {
        "removepackage_$name":
            command => "/usr/bin/yum -y erase $name",
            onlyif => "/bin/rpm -ql $name",
    }
  }

  $oldrelease = [ 'centos-release-openstack-train',
                ]

 ## FF non serve per xena
 # $oldpackage = [ 'centos-release-ceph-luminous',
 #               ]

  $newrelease =  'centos-release-openstack-xena'

  $yumutils = 'yum-utils'

### FF non serve piu'
#case $operatingsystemrelease {
#    /^7.*/: {
#        $centos7 = true
#        $centos8 = false
#        $pythonnetwork = 'python2-networkx.noarch'
#        $genericpackages = ["crudini",
#                            "yum-plugin-priorities",
#                            "ipset",
#                            "sysfsutils", ]
#    }
#    /^8.*/: {
#        $centos7 = false
#        $centos8 = true
#        $pythonnetwork = 'python3-networkx.noarch'
#        $genericpackages = ["crudini",
#                            "ipset",
#                            "sysfsutils", ]
#    }
#}


  $genericpackages = [ "crudini",
                       "ipset",
                       "sysfsutils", ]

  $neutronpackages = [ "openstack-neutron",
                       "openstack-neutron-openvswitch",
                       "openstack-neutron-common",
                       "openstack-neutron-ml2", ]

  $novapackages = [ "openstack-nova-compute",
                     "openstack-nova-common", ]

  file { "/etc/yum/vars/contentdir":
         path    => '/etc/yum/vars/contentdir',
         ensure  => 'present',
         content => 'centos',
  } ->

  compute_xena::install::removepackage{
     $oldrelease :
  } ->

  #compute_xena::install::removepackage{
  #   $oldpackage :
  #} ->

  exec { "removestring_failover":
            command => "/usr/bin/sed -i \"/failovermethod/d\" /etc/yum.repos.d/puppet5.repo",
            onlyif => "/usr/bin/grep failovermethod=priority /etc/yum.repos.d/puppet5.repo",
  } ->

  package { $yumutils :
    ensure => 'installed',
  } ->

# enable PowerTools repo (only for CentOS8)
  exec { "yum enable PowerTools repo":
         command => "/usr/bin/yum-config-manager --enable powertools",
         unless => "/usr/bin/yum repolist enabled | grep -i powertools",
         timeout => 3600,
         require => Package[$yumutils],
  } ->

# Esegue yum clean all once (lo si fa a meno che non stiamo gia` usando il repo xena)
  exec { "clean repo cache":
         command => "/usr/bin/yum clean all",
         unless => "/bin/rpm -q centos-release-openstack-xena",
  } ->

  package { $newrelease :
    ensure => 'installed',
  } ->

  ### negli update si consiglia di disabilitare EPEL (epel-next e' l'unico abilitato da disabilitare) 
  exec { "yum disable EPEL repo":
         command => "/usr/bin/yum-config-manager --disable epel\*",
         onlyif => "/bin/rpm -qa | grep centos-release-openstack-xena && /usr/bin/yum repolist enabled | grep epel",
         timeout => 3600,
         require => Package[$yumutils],
  } -> 

## FF in xena forse questo non serve piu', da provare ##
  exec { "yum update for update from Train in DELL hosts":
         command => "/usr/bin/yum -y --disablerepo dell-system-update_independent --disablerepo dell-system-update_dependent -x facter update",
         onlyif => "/bin/rpm -qi dell-system-update | grep 'Architecture:' &&  /usr/bin/yum list installed | grep openstack-neutron.noarch | grep -i 'train'",
         timeout => 3600,
  } ->

  exec { "yum update for update from Train":
         command => "/usr/bin/yum -y update",
         onlyif => "/bin/rpm -qi dell-system-update | grep 'not installed' &&  /usr/bin/yum list installed | grep openstack-neutron.noarch | grep -i 'train'",
         timeout => 3600,
  } ->
#####

# Rename nova config file  
  exec { "mv_nova_conf_old":
         command => "/usr/bin/mv /etc/nova/nova.conf /etc/nova/nova.conf.train",
         onlyif  => "/usr/bin/test -e /etc/nova/nova.conf.rpmnew",
  } ->
 
  exec { "mv_nova_conf_new":
         command => "/usr/bin/mv /etc/nova/nova.conf.rpmnew /etc/nova/nova.conf",
         onlyif  => "/usr/bin/test -e /etc/nova/nova.conf.rpmnew",
  } ->

# Rename neutron config file  
  exec { "mv_neutron_conf_old":
         command => "/usr/bin/mv /etc/neutron/neutron.conf /etc/neutron/neutron.conf.train",
         onlyif  => "/usr/bin/test -e /etc/neutron/neutron.conf.rpmnew",
  } ->

  exec { "mv_neutron_conf_new":
         command => "/usr/bin/mv /etc/neutron/neutron.conf.rpmnew /etc/neutron/neutron.conf",
         onlyif  => "/usr/bin/test -e /etc/neutron/neutron.conf.rpmnew",
  } ->

  exec { "mv_neutron_openvswitch_old":
         command => "/usr/bin/mv /etc/neutron/plugins/ml2/openvswitch_agent.ini /etc/neutron/plugins/ml2/openvswitch_agent.ini.train",
         onlyif  => "/usr/bin/test -e /etc/neutron/plugins/ml2/openvswitch_agent.ini.rpmnew",
  } ->

  exec { "mv_neutron_openvswitch_new":
         command => "/usr/bin/mv /etc/neutron/plugins/ml2/openvswitch_agent.ini.rpmnew /etc/neutron/plugins/ml2/openvswitch_agent.ini",
         onlyif  => "/usr/bin/test -e /etc/neutron/plugins/ml2/openvswitch_agent.ini.rpmnew",
  } ->


  exec { "mv_neutron_ml2_old":
         command => "/usr/bin/mv /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini.train",
         onlyif  => "/usr/bin/test -e /etc/neutron/plugins/ml2/ml2_conf.ini.rpmnew",
  } ->

  exec { "mv_neutron_ml2_new":
         command => "/usr/bin/mv /etc/neutron/plugins/ml2/ml2_conf.ini.rpmnew /etc/neutron/plugins/ml2/ml2_conf.ini",
         onlyif  => "/usr/bin/test -e /etc/neutron/plugins/ml2/ml2_conf.ini.rpmnew",
  } ->


## Install generic packages
  package { $genericpackages: 
    ensure => "installed",
    require => Package[$newrelease]
   } ->

  package { $neutronpackages: 
    ensure => "installed",
    require => Package[$newrelease]
  } ->

  package { $novapackages: 
    ensure => "installed",
    require => Package[$newrelease]
  } ->

# Eseguo uno yum update se il pacchetto python*-networkx.noarch non proviene dal repo xena
# (Il nome del pacchetto varia tra centos7 e centos8)
# Serve almeno per installazioni da scratch su centos8
  exec { "yum update in DELL hosts":
         command => "/usr/bin/yum -y --disablerepo dell-system-update_independent --disablerepo dell-system-update_dependent -x facter update",
         onlyif => "/bin/rpm -q dell-system-update &&  /usr/bin/yum list installed | grep python3-networkx | grep -v 'centos-openstack-xena'",
         timeout => 3600,
  } ->

  exec { "yum update":
         command => "/usr/bin/yum -y update",
         onlyif => "/bin/rpm -q dell-system-update | grep 'not installed' &&  /usr/bin/yum list installed | grep python3-networkx | grep -v 'centos-openstack-xena'",
         timeout => 3600,
  } ->

  
  file_line { '/etc/sudoers.d/neutron  syslog':
               path   => '/etc/sudoers.d/neutron',
               line   => 'Defaults:neutron !requiretty, !syslog',
               match  => 'Defaults:neutron !requiretty',
            }
 
if $::compute_xena::cloud_role == "is_prod_localstorage" or $::compute_xena::cloud_role ==  "is_prod_sharedstorage" {

   package { 'glusterfs-fuse':
              ensure => 'installed',
           }
 } 
}
