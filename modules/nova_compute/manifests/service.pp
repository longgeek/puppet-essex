class nova_compute::service {
    service { ["openstack-nova-network", "libvirtd", "openstack-nova-compute", "rpcbind"]:
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        enable => true,
        require => File["/etc/nova/api-paste.ini"],
        notify => Exec["nova_db_sync"],
    }
}
