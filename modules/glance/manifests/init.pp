class glance {

    package { ["openstack-glance", "python-glance"]:
        ensure => installed,
        notify => File["/etc/glance/glance-api.conf"],
    }

    file { "/etc/glance/glance-api.conf":
        content => template("glance/glance-api.conf.erb"), 
        group => "glance",
        mode => 644,
        notify => File["/etc/glance/glance-api-paste.ini"],
    }
    
    file { "/etc/glance/glance-api-paste.ini":
        content => template("glance/glance-api-paste.ini.erb"),
        group => "glance",
        mode => 644,
        notify => File["/etc/glance/glance-registry.conf"],
    }

    file { "/etc/glance/glance-registry.conf":
        content => template("glance/glance-registry.conf.erb"),
        group => "glance",
        mode => 644,
        notify => File["/etc/glance/glance-registry-paste.ini"],
    }

    file { "/etc/glance/glance-registry-paste.ini":
        content => template("glance/glance-registry-paste.ini.erb"),
        group => "glance",
        mode => 644,
        notify => File["/etc/glance/cirros.img"],
    }

    file { "/etc/glance/cirros.img":
        source => "puppet:///modules/glance/cirros.img",
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["openstack-glance-api"],
    }

    service { "openstack-glance-api":
        ensure => running,
        hasstatus => true,
        enable => true,
        notify => Service["openstack-glance-registry"],
    }

    service { "openstack-glance-registry":
        ensure => running,
        hasstatus => true,
        enable => true,
        notify => Exec["glance_db_sync"],
    }

    exec { "glance_db_sync":
        command => "glance-manage db_sync",
        path => $command_path,
        refreshonly => true,
        notify => Exec["glance_iptables"],
    }

    exec { "glance_iptables":
        command => "mkdir -p /etc/.openstack/glance;
                    source /etc/profile;
                    glance --os_username=$admin_user --os_password=$admin_password --os_tenant=$admin_tenant --os_auth_url=http://$keystone_lan_ip:5000/v2.0 add name='cirros_test' is_public=true container_format=ovf disk_format=qcow2 < /etc/glance/cirros.img;
                    iptables -I INPUT 1 -p tcp --dport 9191 -j ACCEPT;
                    iptables -I INPUT 1 -p tcp --dport 9292 -j ACCEPT;
                    /etc/init.d/iptables save;
                    ",
        path => $command_path,
        creates => "/etc/.openstack/glance",
    }
}
