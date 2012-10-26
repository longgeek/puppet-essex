class nova_control::service {
    service { ["openstack-nova-api", "openstack-nova-cert", "openstack-nova-network", "openstack-nova-scheduler", "openstack-nova-novncproxy", "openstack-nova-consoleauth"]:
        ensure => running,
        hasstatus => true,
        enable => true,
        require => File ["/etc/nova/api-paste.ini"],
        notify => Exec["nova_db_sync"],
    }
}
