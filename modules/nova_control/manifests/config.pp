class nova_control::config {
    file { "/etc/nova/nova.conf":
        content => template("nova_control/nova.conf.erb"),
        owner => "root",
        group => "nova",
        mode => 644,
        require => Package["openstack-nova","openstack-nova-novncproxy"],
        notify => Class["nova_control::service"],
    }

    file { "/etc/nova/api-paste.ini":
        content => template("nova_control/api-paste.ini.erb"),
        owner => "root",
        group => "nova",
        mode => 644,
        require => File["/etc/nova/nova.conf"],
        notify => Class["nova_control::service"],
    }
}
