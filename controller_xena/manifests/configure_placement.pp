class controller_xena::configure_placement inherits controller_xena::params {

#
# Questa classe:
# - popola il file /etc/placement/placement.conf
# - crea il file /etc/placement/policy.json
# 
###################  
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


# placement.conf
   controller_xena::configure_placement::do_config { 'placement_db': conf_file => '/etc/placement/placement.conf', section => 'placement_database', param => 'connection', value => $controller_xena::params::placement_db, }

   controller_xena::configure_placement::do_config { 'placement_auth_strategy': conf_file => '/etc/placement/placement.conf', section => 'api', param => 'auth_strategy', value => $controller_xena::params::auth_strategy, }

   controller_xena::configure_placement::do_config { 'placement_auth_url': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'auth_url', value => $controller_xena::params::placement_auth_url, }  
   controller_xena::configure_placement::do_config { 'placement_memcached_servers': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'memcached_servers', value => $controller_xena::params::memcached_servers, }
   controller_xena::configure_placement::do_config { 'placement_auth_plugin': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'auth_type', value => $controller_xena::params::auth_type, }
   controller_xena::configure_placement::do_config { 'placement_project_domain_name': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'project_domain_name', value => $controller_xena::params::project_domain_name, }
   controller_xena::configure_placement::do_config { 'placement_user_domain_name': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'user_domain_name', value => $controller_xena::params::user_domain_name, }
   controller_xena::configure_placement::do_config { 'placement_project_name': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'project_name', value => $controller_xena::params::project_name, }
   controller_xena::configure_placement::do_config { 'placement_username': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'username', value => $controller_xena::params::placement_username, }
   controller_xena::configure_placement::do_config { 'placement_password': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'password', value => $controller_xena::params::placement_password, }
   controller_xena::configure_placement::do_config { 'placement_www_authenticate_uri': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'www_authenticate_uri', value => $controller_xena::params::www_authenticate_uri, }
   controller_xena::configure_placement::do_config { 'placement_cafile': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'cafile', value => $controller_xena::params::cafile, }

 # MS In xena da` un warning se questo non e` a true
   controller_xena::configure_placement::do_config { 'placement_service_token_roles_required': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'service_token_roles_required', value => $controller_xena::params::placement_service_token_roles_required, }



######placement_policy is copied from /controller_xena/files dir       
file {'placement_policy.json':
           source      => 'puppet:///modules/controller_xena/placement_policy.json',
           path        => '/etc/placement/policy.json',
           backup      => true,
           owner   => root,
           group   => placement,
           mode    => "0640",

         }
      
## FF       
file {'00-placement-api.conf':
           source      => 'puppet:///modules/controller_xena/00-placement-api.conf',
           path        => '/etc/httpd/conf.d/00-placement-api.conf',
           ensure      => present,
           backup      => true,
           mode        => "0640",
         }
##

}
