class nova_compute::config {
    file { "/etc/nova/nova.conf.sh":
        content => template("nova_compute/nova.conf.sh.erb"),
        owner => "root",
        group => "nova",
        mode => 644,
        require => Package["openstack-nova", "libvirt"],
        notify => Exec["nova_conf"],
    }

    file { "/etc/nova/api-paste.ini":
        content => template("nova_compute/api-paste.ini.erb"),
        owner => "root",
        group => "nova",
        mode => 644,
        require => File["/etc/nova/nova.conf.sh"],
        notify => Service["openstack-nova-network", "libvirtd", "openstack-nova-compute"],
    }

    file { "/etc/libvirt/nwfilter/nova-base.xml":
        source => "puppet:///modules/nova_compute/nova-base.xml",
        owner => "root",
        group => "root",
        mode => 600,
        require => File["/etc/nova/api-paste.ini"],
    }

    file { "/etc/libvirt/nwfilter/nova-vpn.xml":
        source => "puppet:///modules/nova_compute/nova-vpn.xml",
        owner => "root",
        group => "root",
        mode => 600,
        require => File["/etc/libvirt/nwfilter/nova-base.xml"],
    }

    file { "/etc/libvirt/nwfilter/nova-allow-dhcp-server.xml":
        source => "puppet:///modules/nova_compute/nova-allow-dhcp-server.xml",
        owner => "root",
        group => "root",
        mode => 600,
        require => File["/etc/libvirt/nwfilter/nova-vpn.xml"],
    }
}
