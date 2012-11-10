class keystone::service {
    service { "openstack-keystone":
        ensure => running,
        hasstatus => true,
        enable => true,
        require => File["/etc/keystone/keystone.sh"],
        notify => Exec["db_sync"],
    }
}
