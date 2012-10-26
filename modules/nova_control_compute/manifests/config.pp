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
}
