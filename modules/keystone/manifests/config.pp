class keystone::config {
    file { "/etc/keystone/keystone.conf":
        content => template("keystone/keystone.conf.erb"),
        owner => "keystone",
        group => "keystone",
        mode => 640,
        require => Package["openstack-keystone"],
    }

    file { "/etc/keystone/keystone.sh":
        content => template("keystone/keystone.sh.erb"),
        owner => "keystone",
        group => "keystone",
        mode => 640,
        require => File["/etc/keystone/keystone.conf"],
        notify => Exec["db_sync"],
    }
}
