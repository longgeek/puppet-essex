class nova_control_compute::config {
    file { "/etc/nova/nova.conf":
        content => template("nova_control_compute/nova.conf.erb"),
        owner => "root",
        group => "nova",
        mode => 644,
        require => Class["nova_control_compute::install"],
        notify => Class["nova_control_compute::service"],
    }

    file { "/etc/nova/api-paste.ini":
        content => template("nova_control_compute/api-paste.ini.erb"),
        owner => "root",
        group => "nova",
        mode => 644,
        require => Class["nova_control_compute::install"],
        notify => Class["nova_control_compute::service"],
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
