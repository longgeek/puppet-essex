class keystone {

    package { "openstack-keystone":
        ensure => installed,
        notify => File["/etc/keystone/keystone.conf"],
    }

    file { "/etc/keystone/keystone.conf":
        content => template("keystone/keystone.conf.erb"),
        owner => "keystone",
        group => "keystone",
        mode => 640,
        notify => File["/etc/keystone/keystone.sh"],
    }

    file { "/etc/keystone/keystone.sh":
        content => template("keystone/keystone.sh.erb"),
        owner => "keystone",
        group => "keystone",
        mode => 640,
        notify => Service["openstack-keystone"],
    }

    service { "openstack-keystone":
        ensure => running,
        hasstatus => true,
        enable => true,
        notify => Exec["db_sync"],
    }

    exec { "db_sync":
        command => "keystone-manage db_sync;
                    sh /etc/keystone/keystone.sh;",
        path => $command_path,
        refreshonly => true,
        notify => Exec["keystone_iptables"],
    } 
	
    exec { "keystone_iptables":
        command => "mkdir -p /etc/.openstack/keystone;
            iptables -I INPUT 1 -p tcp --dport 5000 -j ACCEPT;
            iptables -I INPUT 1 -p tcp --dport 35357 -j ACCEPT;
            /etc/init.d/iptables save",
        creates => "/etc/.openstack/keystone",
        path => $command_path,
    }
}
