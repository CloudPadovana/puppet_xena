class compute_xena::neutron inherits compute_xena::params {

# include compute_xena::params
 include compute_xena::install

# $neutronpackages = [   "openstack-neutron-openvswitch",
#                         "openstack-neutron-common",
#                         "openstack-neutron-ml2" ]
#  package { $neutronpackages: ensure => "installed" }


  file { '/etc/neutron/neutron.conf':
          ensure     => present,
          require    => Package["openstack-neutron-common"],
       }

  file { '/etc/neutron/plugins/ml2/ml2_conf.ini':
          ensure   => present,
          require    => Package["openstack-neutron-ml2"],
       }

  file { '/etc/neutron/plugins/ml2/openvswitch_agent.ini':
          ensure   => present,
          require    => Package["openstack-neutron-openvswitch"],
       }

  file {'/etc/neutron/plugin.ini':
            ensure      => link,
            target      => '/etc/neutron/plugins/ml2/ml2_conf.ini',
            require     => Package['openstack-neutron-ml2']
       }

  define do_config ($conf_file, $section, $param, $value) {
           exec { "${name}":
                             command     => "/usr/bin/crudini --set ${conf_file} ${section} ${param} \"${value}\"",
                             require     => Package['crudini'],
                             unless      => "/usr/bin/crudini --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"^${value}$\" 2>&1 >/dev/null",
                }
       }

  define remove_config ($conf_file, $section, $param, $value) {
           exec { "${name}":
                              command     => "/usr/bin/crudini --del ${conf_file} ${section} ${param}",
                              require     => Package['crudini'],
                              onlyif      => "/usr/bin/crudini --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"^${value}$\" 2>&1 >/dev/null",
                }
       }

#neutron.conf
####verificare
###  compute_xena::neutron::do_config { 'neutron_rpc_backend': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'rpc_backend', value => $compute_xena::params::rpc_backend, }
####rpc_backend sostituito da transport url
  compute_xena::neutron::do_config { 'neutron_transport_url': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'transport_url', value => $compute_xena::params::transport_url, }

####

  compute_xena::neutron::do_config { 'neutron_auth_strategy': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'auth_strategy', value => $compute_xena::params::auth_strategy, }

  ### FF erano da controllare in OCATA, controllare ora se vanno mantenuti in ROCKY 
  compute_xena::neutron::do_config { 'neutron_core_plugin': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'core_plugin', value => $compute_xena::params::core_plugin, }
  compute_xena::neutron::do_config { 'neutron_service_plugins': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'service_plugins', value => $compute_xena::params::service_plugins, }
  compute_xena::neutron::do_config { 'neutron_allow_overlapping_ips': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'allow_overlapping_ips', value => $compute_xena::params::allow_overlapping_ips, }
  ###
  compute_xena::neutron::do_config { 'neutron_keystone_authtoken_memcached_servers': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'memcached_servers', value => $compute_xena::params::memcached_servers, }
  compute_xena::neutron::do_config { 'neutron_username': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'username', value => $compute_xena::params::neutron_username, }
  compute_xena::neutron::do_config { 'neutron_password': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'password', value => $compute_xena::params::neutron_password, }
  compute_xena::neutron::do_config { 'neutron_auth_type': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'auth_type', value => $compute_xena::params::auth_type}
  compute_xena::neutron::do_config { 'neutron_project_domain_name': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'project_domain_name', value => $compute_xena::params::project_domain_name, }
  compute_xena::neutron::do_config { 'neutron_user_domain_name': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'user_domain_name', value => $compute_xena::params::user_domain_name, }
  compute_xena::neutron::do_config { 'neutron_project_name': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'project_name', value => $compute_xena::params::project_name, }
  compute_xena::neutron::do_config { 'neutron_cafile': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'cafile', value => $compute_xena::params::cafile, }
  ## FF in rocky [keystone_authtoken] auth_uri diventa www_authenticate_uri
  #compute_xena::neutron::do_config { 'neutron_auth_uri': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'auth_uri', value => $compute_xena::params::auth_uri, }
  compute_xena::neutron::do_config { 'neutron_www_authenticate_uri': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'www_authenticate_uri', value => $compute_xena::params::www_authenticate_uri, }
  ##FF in rocky [keystone_authtoken] auth_url passa da 35357 a 5000
  compute_xena::neutron::do_config { 'neutron_keystone_authtoken_auth_url': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'auth_url', value => $compute_xena::params::neutron_keystone_authtoken_auth_url, }
########

  compute_xena::neutron::do_config { 'neutron_lock_path': conf_file => '/etc/neutron/neutron.conf', section => 'oslo_concurrency', param => 'lock_path', value => $compute_xena::params::neutron_lock_path, }


   compute_xena::neutron::do_config { "neutron_amqp_durable_queues":
           conf_file => '/etc/neutron/neutron.conf',
           section   => 'oslo_messaging_rabbit',
           param     => 'amqp_durable_queues',
           value    => $compute_xena::params::amqp_durable_queues   ,
         }

   compute_xena::neutron::do_config { "neutron_rabbit_ha_queues":
           conf_file => '/etc/neutron/neutron.conf',
           section   => 'oslo_messaging_rabbit',
           param     => 'rabbit_ha_queues',
           value    => $compute_xena::params::rabbit_ha_queues   ,
         }



#
#ml2_conf.ini
#
 compute_xena::neutron::do_config { 'ml2_type_drivers': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ml2', param => 'type_drivers', value => $compute_xena::params::type_drivers}
 compute_xena::neutron::do_config { 'ml2_tenant_network_types': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ml2', param => 'tenant_network_types', value => $compute_xena::params::tenant_network_types}
 compute_xena::neutron::do_config { 'ml2_mechanism_drivers': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ml2', param => 'mechanism_drivers', value => $compute_xena::params::mechanism_drivers}
 compute_xena::neutron::do_config { 'ml2_tunnel_id_ranges': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ml2_type_gre', param => 'tunnel_id_ranges', value => $compute_xena::params::tunnel_id_ranges}
 compute_xena::neutron::do_config { 'ml2_enable_ipset': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'securitygroup', param => 'enable_ipset', value => $compute_xena::params::enable_ipset}
 compute_xena::neutron::do_config { 'ml2_enable_security_group': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'securitygroup', param => 'enable_security_group', value => $compute_xena::params::enable_security_group}
 compute_xena::neutron::do_config { 'ml2_ovs_local_ip': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ovs', param => 'local_ip', value => $compute_xena::params::ovs_local_ip}
 compute_xena::neutron::do_config { 'ml2_tunnel_types': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'agent', param => 'tunnel_types', value => $compute_xena::params::tunnel_types}
####ok ml2_conf

#
#openvswitch_agent.ini
#
 compute_xena::neutron::do_config { 'ovs_tunnel_types': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'agent', param => 'tunnel_types', value => $compute_xena::params::tunnel_types}
 compute_xena::neutron::do_config { 'ovs_ovs_local_ip': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'ovs', param => 'local_ip', value => $compute_xena::params::ovs_local_ip}
 compute_xena::neutron::do_config { 'ovs_ovs_enable_tunneling': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'ovs', param => 'enable_tunneling', value => $compute_xena::params::enable_tunneling}
 compute_xena::neutron::do_config { 'ovs_firewall_driver': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'securitygroup', param => 'firewall_driver', value => $compute_xena::params::neutron_firewall_driver}

####################
#####mancano 2 valori in ovs ovsdb_interface e of_interface                
 ### FF DEPRECATED IN QUEENS: The ovsdb_interface configuration option is now deprecated. In future releases, the value of the option will be ignored. The native driver will then be used.                
 #compute_xena::neutron::do_config { 'ovs_ovsdb_interface': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'ovs', param => 'ovsdb_interface', value => $compute_ocata::params::ovs_ovsdb_interface}
 ###
 ### FF DEPRECATED in PIKE of_interface Open vSwitch agent configuration option --> the current default driver (native) will be the only supported of_interface driver
 #compute_xena::neutron::do_config { 'ovs_of_interface': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'ovs', param => 'of_interface', value => $compute_ocata::params::ovs_of_interface}
 ###
###################################

##  compute_xena::neutron::do_config { 'nova_network_api': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'network_api_class', value => $compute_xena::params::network_api_class, }
##  compute_xena::neutron::do_config { 'nova_security_group_api': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'security_group_api', value => $compute_xena::params::security_group_api, }
##  compute_xena::neutron::do_config { 'nova_vif_plugging_is_fatal': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'vif_plugging_is_fatal', value => $compute_xena::params::vif_plugging_is_fatal, }
##  compute_xena::neutron::do_config { 'nova_vif_plugging_timeout': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'vif_plugging_timeout', value => $compute_xena::params::vif_plugging_timeout, }                               
## compute_xena::neutron::do_config { 'ml2_firewall_driver': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'securitygroup', param => 'firewall_driver', value => $compute_xena::params::neutron_firewall_driver}
## compute_xena::neutron::do_config { 'ml2_ovs_tenant_network_type': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ovs', param => 'tenant_network_type', value => $compute_xena::params::tenant_network_types}
## compute_xena::neutron::do_config { 'ml2_ovs_tunnel_id_ranges': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ovs', param => 'tunnel_id_ranges', value => $compute_xena::params::tunnel_id_ranges}
## compute_xena::neutron::do_config { 'ml2_ovs_enable_tunneling': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ovs', param => 'enable_tunneling', value => $compute_xena::params::enable_tunneling}
## compute_xena::neutron::do_config { 'ml2_ovs_integration_bridge': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ovs', param => 'integration_bridge', value => $compute_xena::params::integration_bridge}
## compute_xena::neutron::do_config { 'ml2_ovs_tunnel_bridge': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ovs', param => 'tunnel_bridge', value => $compute_xena::params::tunnel_bridge}

}
