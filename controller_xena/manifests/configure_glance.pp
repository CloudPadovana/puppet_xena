class controller_xena::configure_glance inherits controller_xena::params {

#
# Questa classe:
# Crea la directory per node_staging_uri
# - popola il file /etc/glance/glance-api.conf
# - crea il file /etc/glance/policy.yaml

# Changes wrt default:
# role:admin required for delete_image_location, get_image_location, set_image_location
# See https://wiki.openstack.org/wiki/OSSN/OSSN-0065

  
    file { "/etc/glance/policy.yaml":
            ensure   => file,
            owner    => "root",
            group    => "glance",
            mode     => "0640",
            source  => "puppet:///modules/controller_xena/glance.policy.yaml",
          }
          
  

    file { $controller_xena::params::glance_api_node_staging_path:
            ensure => 'directory',
            owner  => 'glance',
            group  => 'glance',
            mode   => "0750",
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
                                                                                                                                             
# glance-api.conf

# 25 GB max size for an image
  controller_xena::configure_glance::do_config { 'glance_image_size_cap': conf_file => '/etc/glance/glance-api.conf', section => 'DEFAULT', param => 'image_size_cap', value => $controller_xena::params::glance_image_size_cap, }
  controller_xena::configure_glance::do_config { 'glance_api_show_image_direct_url': conf_file => '/etc/glance/glance-api.conf', section => 'DEFAULT', param => 'show_image_direct_url', value => $controller_xena::params::glance_api_show_image_direct_url, }
  controller_xena::configure_glance::do_config { 'glance_api_enabled_backends': conf_file => '/etc/glance/glance-api.conf', section => 'DEFAULT', param => 'enabled_backends', value => $controller_xena::params::glance_api_enabled_backends, }
  controller_xena::configure_glance::do_config { 'glance_log_dir': conf_file => '/etc/glance/glance-api.conf', section => 'DEFAULT', param => 'log_dir', value => $controller_xena::params::glance_log_dir, }
  controller_xena::configure_glance::do_config { 'glance_api_filesystem_store_datadir': conf_file => '/etc/glance/glance-api.conf', section => 'os_glance_staging_store', param => 'filesystem_store_datadir', value => $controller_xena::params::glance_api_filesystem_store_datadir, }

  controller_xena::configure_glance::do_config { 'glance_api_db': conf_file => '/etc/glance/glance-api.conf', section => 'database', param => 'connection', value => $controller_xena::params::glance_db, }

  controller_xena::configure_glance::do_config { 'glance_api_www_authenticate_uri': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'www_authenticate_uri', value => $controller_xena::params::www_authenticate_uri, }
  controller_xena::configure_glance::do_config { 'glance_api_auth_url': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'auth_url', value => $controller_xena::params::glance_auth_url, }
  controller_xena::configure_glance::do_config { 'glance_api_project_domain_name': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'project_domain_name', value => $controller_xena::params::project_domain_name, }
  controller_xena::configure_glance::do_config { 'glance_api_user_domain_name': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'user_domain_name', value => $controller_xena::params::user_domain_name, }
  controller_xena::configure_glance::do_config { 'glance_api_project_name': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'project_name', value => $controller_xena::params::project_name, }
  controller_xena::configure_glance::do_config { 'glance_api_username': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'username', value => $controller_xena::params::glance_username, }
  controller_xena::configure_glance::do_config { 'glance_api_password': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'password', value => $controller_xena::params::glance_password, }
  controller_xena::configure_glance::do_config { 'glance_api_cafile': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'cafile', value => $controller_xena::params::cafile, }
  controller_xena::configure_glance::do_config { 'glance_api_memcached_servers': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'memcached_servers', value => $controller_xena::params::memcached_servers, }
  controller_xena::configure_glance::do_config { 'glance_api_auth_type': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'auth_type', value => $controller_xena::params::auth_type, }

# C'e` un warning che dice che questo deve essere a true, ma almeno per alcuni servizi la cosa da` problemi
#  controller_xena::configure_glance::do_config { 'glance_service_token_roles_required': conf_file => '/etc/glance/glance-api.conf', section => 'keystone_authtoken', param => 'service_token_roles_required ', value => $controller_xena::params::glance_service_token_roles_required, }

  controller_xena::configure_glance::do_config { 'glance_api_flavor': conf_file => '/etc/glance/glance-api.conf', section => 'paste_deploy', param => 'flavor', value => $controller_xena::params::flavor, }

  controller_xena::configure_glance::do_config { 'glance_api_default_store': conf_file => '/etc/glance/glance-api.conf', section => 'glance_store', param => 'default_backend', value => $controller_xena::params::glance_api_default_store, }
# File backend       
  controller_xena::configure_glance::do_config { 'glance_api_store_datadir': conf_file => '/etc/glance/glance-api.conf', section => 'glance_store', param => 'filesystem_store_datadir', value => $controller_xena::params::glance_store_datadir, }

# Ceph backend       
  controller_xena::configure_glance::do_config { 'glance_api_rbd_store_description': conf_file => '/etc/glance/glance-api.conf', section => 'rbd', param => 'store_description', value => $controller_xena::params::glance_api_rbd_store_description, }
  controller_xena::configure_glance::do_config { 'glance_api_rbd_store_pool': conf_file => '/etc/glance/glance-api.conf', section => 'rbd', param => 'rbd_store_pool', value => $controller_xena::params::glance_api_rbd_store_pool, }
  controller_xena::configure_glance::do_config { 'glance_api_rbd_store_user': conf_file => '/etc/glance/glance-api.conf', section => 'rbd', param => 'rbd_store_user', value => $controller_xena::params::glance_api_rbd_store_user, }
  controller_xena::configure_glance::do_config { 'glance_api_rbd_store_ceph_conf': conf_file => '/etc/glance/glance-api.conf', section => 'rbd', param => 'rbd_store_ceph_conf', value => $controller_xena::params::ceph_rbd_ceph_conf, }
  controller_xena::configure_glance::do_config { 'glance_api_rbd_store_chunk_size': conf_file => '/etc/glance/glance-api.conf', section => 'rbd', param => 'rbd_store_chunk_size', value => $controller_xena::params::glance_api_rbd_store_chunk_size, }
       
###############
# Settings needed for ceilomer
# Probably useess now (but doesn't cause problems)       
  controller_xena::configure_glance::do_config { 'glance_api_transport_url': conf_file => '/etc/glance/glance-api.conf', section => 'DEFAULT', param => 'transport_url', value => $controller_xena::params::transport_url, }
   
#######Proxy headers parsing
  controller_xena::configure_glance::do_config { 'glance_enable_proxy_headers_parsing': conf_file => '/etc/glance/glance-api.conf', section => 'oslo_middleware', param => 'enable_proxy_headers_parsing', value => $controller_xena::params::enable_proxy_headers_parsing, }

  controller_xena::configure_glance::do_config { 'glance_api_rabbit_ha_queues': conf_file => '/etc/glance/glance-api.conf', section => 'oslo_messaging_rabbit', param => 'rabbit_ha_queues', value => $controller_xena::params::rabbit_ha_queues, }
  controller_xena::configure_glance::do_config { 'glance_api_amqp_durable_queues': conf_file => '/etc/glance/glance-api.conf', section => 'oslo_messaging_rabbit', param => 'amqp_durable_queues', value => $controller_xena::params::amqp_durable_queues, }

  controller_xena::configure_glance::do_config { 'glance_policy': conf_file => '/etc/glance/glance-api.conf', section => 'oslo_policy', param => 'policy_file', value => $controller_xena::params::glance_policy_file, }

}
