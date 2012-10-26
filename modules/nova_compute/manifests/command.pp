class nova_compute::command {
    exec { "nova_conf":
        command => "sh /etc/nova/nova.conf.sh",
        path => $command_path,
        refreshonly => true,
		notify => Service["openstack-nova-network", "libvirtd", "openstack-nova-compute"],
    }

    exec { "nova_db_sync":
		command => "nova-manage db sync",
		path => $command_path,
		refreshonly => true,
    }

    exec { "nova_iptables":
        command => "mkdir -p /tmp/test/nova_compute;
                    iptables -I INPUT 1 -p tcp -m multiport --dport 5900:6200,53 -j ACCEPT;
                    iptables -I INPUT 1 -p udp -m multiport --dport 53,67 -j ACCEPT;
                    /etc/init.d/iptables save;
                   ",
        path => $command_path,
		creates => "/tmp/test/nova_compute",
		require => Exec["nova_db_sync"],
    }
}
