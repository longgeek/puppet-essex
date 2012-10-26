class nova_control_compute::command {
    exec { "nova_control_compute_db_sync":
        command => "nova-manage db sync;
                    nova-manage network create private --fixed_range_v4=$fixed_range
                    --num_netwroks=1 --bridge=br100 --bridge_interface=$flat_interface --network_size=$network_size;
                    nova-manage floating create --ip_range=$floating_range;
                    ",
        path => $command_path,
        refreshonly => true,
    }

    exec { "nova_control_compute_iptables":
        command => "mkdir -p /tmp/test/nova_control_compute;
                    iptables -I INPUT 1 -p tcp -m multiport --dport 8773:8776,6080,5900:6200 -j ACCEPT;
                    /etc/init.d/iptables save;
					source /etc/profile;
                    nova secgroup-add-rule default tcp 22 22 0.0.0.0/0;
                    nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0;
                    ",
        path => $command_path,
		creates => "/tmp/test/nova_control_compute",
		require => Exec["nova_control_compute_db_sync"],
    }
}
