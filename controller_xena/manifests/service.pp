class controller_xena::service inherits controller_xena::params {
  
 ## Services

 service { "memcached":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_horizon'],
           }


# service { "fetch-crl-cron":
#                   ensure      => running,
#                   enable      => true,
#                   hasstatus   => true,
#                   hasrestart  => true,
#           }

file { "/etc/cron.d/fetch-crl":
    ensure   => file,
    owner    => "root",
    group    => "root",
    mode     => "0600",
    content  => file("controller_xena/fetch-crl.cron"),
  }



 ## FF added placement in Train ##       
 # Services for keystone, placement       
    service { "httpd":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => [ Class['controller_xena::configure_keystone'], Class['controller_xena::configure_horizon'], Class['controller_xena::configure_placement'], ],
           }

 # Services for Glance
    service { "openstack-glance-api":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_glance'],
           }
## PEM glance-registry disabled since stein
#    service { "openstack-glance-registry":
#                   ensure      => running,
#                   enable      => true,
#                   hasstatus   => true,
#                   hasrestart  => true,
#                   subscribe   => Class['controller_xena::configure_glance'],
#            }

 # Services for nova       
    service { "openstack-nova-api":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_nova'],
           }
## FF deprecated since 18.0.0 (Rocky)
#    service { "openstack-nova-consoleauth":
#                   ensure      => running,
#                  enable      => true,
#                   hasstatus   => true,
#                   hasrestart  => true,
#                   subscribe   => Class['controller_xena::configure_nova'],
#           }
    service { "openstack-nova-scheduler":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_nova'],
           }
    service { "openstack-nova-novncproxy":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_nova'],
           }
    service { "openstack-nova-conductor":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_nova'],
           }
 

 # Services for ec2       
    service { "openstack-ec2-api":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_ec2'],
           }
    service { "openstack-ec2-api-metadata":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_ec2'],
           }

 # Services for neutron       
    service { "openvswitch":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_neutron'],
           }
    service { "neutron-server":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_neutron'],
           }
    service { "neutron-openvswitch-agent":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_neutron'],
           }
    service { "neutron-dhcp-agent":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_neutron'],
           }
    service { "neutron-metadata-agent":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_neutron'],
           }
    service { "neutron-l3-agent":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_neutron'],
           }

 # Services for cinder
    service { "openstack-cinder-api":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_cinder'],
           }
    service { "openstack-cinder-scheduler":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_cinder'],
           }
    service { "openstack-cinder-volume":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_cinder'],
           }
#    service { "target":
#                   ensure      => running,
#                   enable      => true,
#                   hasstatus   => true,
#                   hasrestart  => true,
#                   subscribe   => Class['controller_xena::configure_cinder'],
#           }
           
 # Services for heat
    service { "openstack-heat-api":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_heat'],
           }
    service { "openstack-heat-api-cfn":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_heat'],
           }
    service { "openstack-heat-engine":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_xena::configure_heat'],
           }
           
  }
