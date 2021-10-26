class compute_xena ($cloud_role_foreman = "undefined") { 

  $cloud_role = $cloud_role_foreman  

  # system check setting (network, selinux, CA files)
    class {'compute_xena::systemsetting':}

  # stop services 
    class {'compute_xena::stopservices':}

  # install
    class {'compute_xena::install':}

  # setup firewall
    class {'compute_xena::firewall':}

  # setup bacula
    class {'compute_xena::bacula':}
  
  # setup libvirt
    class {'compute_xena::libvirt':}

  # setup ceph
    class {'compute_xena::ceph':}

  # setup rsyslog
    class {'compute_xena::rsyslog':}

  # service
    class {'compute_xena::service':}

  # install and configure nova
     class {'compute_xena::nova':}

  # install and configure neutron
     class {'compute_xena::neutron':}

  # nagios settings
     class {'compute_xena::nagiossetting':}

  # do passwdless access
      class {'compute_xena::pwl_access':}

    # configure collectd
      class {'compute_xena::collectd':}


# execution order
             Class['compute_xena::firewall'] -> Class['compute_xena::systemsetting']
             Class['compute_xena::systemsetting'] -> Class['compute_xena::stopservices']
             Class['compute_xena::stopservices'] -> Class['compute_xena::install']
             Class['compute_xena::install'] -> Class['compute_xena::bacula']
             Class['compute_xena::bacula'] -> Class['compute_xena::nova']
             Class['compute_xena::nova'] -> Class['compute_xena::libvirt']
             Class['compute_xena::libvirt'] -> Class['compute_xena::neutron']
             Class['compute_xena::neutron'] -> Class['compute_xena::ceph']
             Class['compute_xena::ceph'] -> Class['compute_xena::nagiossetting']
             Class['compute_xena::nagiossetting'] -> Class['compute_xena::pwl_access']
             Class['compute_xena::pwl_access'] -> Class['compute_xena::collectd']
             Class['compute_xena::collectd'] -> Class['compute_xena::service']
################           
}
  
