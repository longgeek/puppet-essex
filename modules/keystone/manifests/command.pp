class keystone::command {
    exec { "db_sync":
        command => "keystone-manage db_sync;
                    sh /etc/keystone/keystone.sh;",
        path => $command_path,
        refreshonly => true,
    } 
	
	exec { "keystone_iptables":
		command => "mkdir -p /tmp/test/keystone;
                    iptables -I INPUT 1 -p tcp --dport 5000 -j ACCEPT;
                    iptables -I INPUT 1 -p tcp --dport 35357 -j ACCEPT;
                    /etc/init.d/iptables save",
		creates => "/tmp/test/keystone",
		path => $command_path,
		require => Service["openstack-keystone"],
	}
}
