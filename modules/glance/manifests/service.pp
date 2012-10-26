class glance::service {
    service { "openstack-glance-api":
        ensure => running,
        hasstatus => true,
        enable => true,
        require => File["/etc/glance/glance-registry-paste.ini"],
        notify => Exec["glance_db_sync"],
    }

    service { "openstack-glance-registry":
        ensure => running,
        hasstatus => true,
        enable => true,
        require => Service["openstack-glance-api"],
        notify => Exec["glance_db_sync"],
    }
}
