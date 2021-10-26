class compute_xena::collectd inherits compute_xena::params {

    $collectdpackages= [ 'collectd', 'collectd-virt' ]
  
    package { $collectdpackages :
              ensure => 'installed',
              install_options => ['--enablerepo', 'epel'],
                   }
                   

   file { "/etc/collectd.conf":
         ensure   => file,
         owner    => "root",
         group    => "root",
         mode     => '0644',
         content  => template("compute_xena/collectd.conf.erb"),
         require => Package[$collectdpackages],
       }


    cron {'collectd_flush_cache':
             ensure      => present,
             command     => "/usr/bin/killall -SIGUSR1 collectd",
             user        => root,
             minute      => '0',
             hour        => '*/2'
          }


   service { "collectd":
                             ensure      => running,
                             enable      => true,
                             hasstatus   => true,
                             hasrestart  => true,
                             require     => Package[$collectdpackages],
                             subscribe   => File['/etc/collectd.conf'],
                    }
                    
       
  }
