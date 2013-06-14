class nova_control {

    package { ["openstack-nova", "openstack-nova-novncproxy"]:
        ensure => installed,
        notify => File["/etc/nova/nova.conf"],
    }

    file { "/etc/nova/nova.conf":
        content => template("nova_control/nova.conf.erb"),
        group => "nova",
        mode => 644,
        notify => File["/etc/nova/api-paste.ini"],
    }

    file { "/etc/nova/api-paste.ini":
        content => template("nova_control/api-paste.ini.erb"),
        group => "nova",
        mode => 644,
        notify => File["/etc/nova/create-nova-volumes.py"],
    }

    file { "/etc/nova/create-nova-volumes.py":
        content => template("nova_control/create-nova-volumes.py.erb"),
        mode => 755,
        notify => Exec["python create-nova-volumes.py"],
    }
  
    exec { "python create-nova-volumes.py":
        command => "python /etc/nova/create-nova-volumes.py",
        path => $command_path,
        subscribe => File["/etc/nova/create-nova-volumes.py"],
        refreshonly => true,
        notify => Service["openstack-nova-api", "openstack-nova-cert", "openstack-nova-network", "openstack-nova-scheduler", "openstack-nova-novncproxy", "openstack-nova-consoleauth", "openstack-nova-volume", "tgtd"],

    }

    service { ["openstack-nova-api", "openstack-nova-cert", "openstack-nova-network", "openstack-nova-scheduler", "openstack-nova-novncproxy", "openstack-nova-consoleauth", "openstack-nova-volume", "tgtd"]:
        ensure => running,
        hasstatus => true,
        enable => true,
        notify => Exec["nova_db_sync"],
    }

    exec { "nova_db_sync":
        command => "nova-manage db sync;
                    nova-manage network create private --fixed_range_v4=$fixed_range --num_networks=1 --bridge=br100 --bridge_interface=$flat_interface --network_size=$network_size --multi_host=T;
                    nova-manage floating create --ip_range=$floating_range --interface=$public_interface;
                    mkdir -p /etc/.openstack/nova_control_sync;
                   ",
        path => $command_path,
        notify => Exec["nova_iptables"],
        creates => "/etc/.openstack/nova_control_sync",
    }

    exec { "nova_iptables":
        command => "mkdir -p /etc/.openstack/nova_control;
                    nova-manage db sync;
                    nova --os_username=$admin_user --os_password=$admin_password --os_tenant_name=$admin_tenant --os_auth_url=http://$keystone_lan_ip:5000/v2.0 secgroup-add-rule default tcp 22 22 0.0.0.0/0;
                    nova --os_username=$admin_user --os_password=$admin_password --os_tenant_name=$admin_tenant --os_auth_url=http://$keystone_lan_ip:5000/v2.0 secgroup-add-rule default icmp -1 -1 0.0.0.0/0;
                    iptables -I INPUT 1 -p tcp -m multiport --dport 8773:8776,6080,3260 -j ACCEPT;
                    /etc/init.d/iptables save;
					",
        path => $command_path,
        creates => "/etc/.openstack/nova_control",
    }
}
