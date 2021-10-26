class controller_xena ($cloud_role_foreman = "undefined") {

  $cloud_role = $cloud_role_foreman

  $ocatapackages = [ "crudini",

                   ]


     package { $ocatapackages: ensure => "installed" }

  # Install CA
  class {'controller_xena::install_ca_cert':}

  # Ceph
  class {'controller_xena::ceph':}
  
  # Configure keystone
  class {'controller_xena::configure_keystone':}
  
  # Configure glance
  class {'controller_xena::configure_glance':}

  # Configure nova
  class {'controller_xena::configure_nova':}

## FF for placement in xena
  # Configure placement
  class {'controller_xena::configure_placement':}
###

  # Configure ec2
  class {'controller_xena::configure_ec2':}

  # Configure neutron
  class {'controller_xena::configure_neutron':}

  # Configure cinder
  class {'controller_xena::configure_cinder':}

  # Configure heat
  class {'controller_xena::configure_heat':}

  # Configure horizon
  class {'controller_xena::configure_horizon':}

  # Configure Shibboleth if AII and Shibboleth are enabled
  if ($::controller_xena::params::enable_aai_ext and $::controller_xena::params::enable_shib)  {
    class {'controller_xena::configure_shibboleth':}
  }

  # Configure OpenIdc if AII and openidc are enabled
  if ($::controller_xena::params::enable_aai_ext and ($::controller_xena::params::enable_oidc or $::controller_xena::params::enable_infncloud))  {
    class {'controller_xena::configure_openidc':}
  }
 
  # Service
  class {'controller_xena::service':}

  
  # do passwdless access
  class {'controller_xena::pwl_access':}
  
  
  # configure remote syslog
  class {'controller_xena::rsyslog':}
  
  

       Class['controller_xena::install_ca_cert'] -> Class['controller_xena::configure_keystone']
       Class['controller_xena::configure_keystone'] -> Class['controller_xena::configure_glance']
       Class['controller_xena::configure_glance'] -> Class['controller_xena::configure_nova']
       Class['controller_xena::configure_nova'] -> Class['controller_xena::configure_placement']
       Class['controller_xena::configure_placement'] -> Class['controller_xena::configure_neutron']
       Class['controller_xena::configure_neutron'] -> Class['controller_xena::configure_cinder']
       Class['controller_xena::configure_cinder'] -> Class['controller_xena::configure_horizon']
       Class['controller_xena::configure_horizon'] -> Class['controller_xena::configure_heat']

  }
