class compute_xena::nagiossetting inherits compute_xena::params {

     file {'nagios_check_ovs':
             source      => 'puppet:///modules/compute_xena/nagios_check_ovs.sh',
             path => '/usr/local/bin/nagios_check_ovs.sh',
             mode => '+x',
             #subscribe   => Class['compute_xena::neutron'],
          }

     file {'nagios_check_kvm':
             source      => 'puppet:///modules/compute_xena/check_kvm',
             path        => '/usr/local/bin/check_kvm',
             mode        => '+x',
             #subscribe   => Class['compute_xena::nova'],
          }

     file {'nagios_check_kvm_wrapper':
             source      => 'puppet:///modules/compute_xena/check_kvm_wrapper.sh',
             path        => '/usr/local/bin/check_kvm_wrapper.sh',
             mode        => '+x',
             require => File['nagios_check_kvm'],
             #subscribe   => Class['compute_xena::nova'],
          }

     file {'check_total_disksize.sh':
             source      => 'puppet:///modules/compute_xena/check_total_disksize.sh',
             path        => '/usr/lib64/nagios/plugins/check_total_disksize.sh',
             mode        => '+x',
             #subscribe   => Class['compute_xena::nova'],
          }

# NAGIOS - various crontabs

     cron {'nagios_check_ovs':
             ensure      => present,
             command     => "/usr/local/bin/nagios_check_ovs.sh",
             user        => root,
             minute      => '*/10',
             hour        => '*',
             require     => File["nagios_check_ovs"]
          }

     cron {'nagios_check_kvm':
             ensure     => present,
             command    => "/usr/local/bin/check_kvm_wrapper.sh",
             user       => root,
             minute      => 0,
             hour        => '*/1',
             require    => File["nagios_check_kvm_wrapper"]
          }
}
