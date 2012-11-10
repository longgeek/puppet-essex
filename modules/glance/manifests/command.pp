class glance::command { 
    exec { "glance_db_sync":
        command => "glance-manage db_sync",
        path => $command_path,
        refreshonly => true,
    }

    exec { "glance_iptables":
        command => "mkdir -p /tmp/test/glance;
                    source /etc/profile;
                    glance --os_username=$admin_user --os_password=$admin_password --os_tenant=$admin_tenant --os_auth_url=http://$keystone_lan_ip:5000/v2.0 add name='cirros_test' is_public=true container_format=ovf disk_format=qcow2 < /etc/glance/cirros.img
                    iptables -I INPUT 1 -p tcp --dport 9191 -j ACCEPT;
                    iptables -I INPUT 1 -p tcp --dport 9292 -j ACCEPT;
                    /etc/init.d/iptables save;
                    ",
        path => $command_path,
		creates => "/tmp/test/glance",
		require => Service["openstack-glance-registry"],
    }
}
