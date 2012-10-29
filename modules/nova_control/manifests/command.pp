class nova_control::command {
    exec { "nova_db_sync":
        command => "nova-manage db sync;
                    nova-manage network create private --fixed_range_v4=$fixed_range --num_networks=1 --bridge=br100 --bridge_interface=$flat_interface --network_size=$network_size --multi_host=T;
                    nova-manage floating create --ip_range=$floating_range;
                   ",
        path => $command_path,
        refreshonly => true,
    }

    exec { "nova_iptables":
        command => "mkdir -p /tmp/test/nova_control;
					nova-manage db sync;
                    nova --os_username=$admin_user --os_password=$admin_password --os_tenant_name=$admin_tenant --os_auth_url=http://$keystone_lan_ip:5000/v2.0 secgroup-add-rule default tcp 22 22 0.0.0.0/0;
                    nova --os_username=$admin_user --os_password=$admin_password --os_tenant_name=$admin_tenant --os_auth_url=http://$keystone_lan_ip:5000/v2.0 secgroup-add-rule default icmp -1 -1 0.0.0.0/0;
                    iptables -I INPUT 1 -p tcp -m multiport --dport 8773:8776,6080 -j ACCEPT;
                    /etc/init.d/iptables save;
					",
        path => $command_path,
		creates => "/tmp/test/nova_control",
		require => Service["openstack-nova-api", "openstack-nova-cert", "openstack-nova-network", "openstack-nova-scheduler", "openstack-nova-novncproxy", "openstack-nova-consoleauth"],
    }
}
