class nova_control_compute::service {
    service { ["openstack-nova-api", "openstack-nova-cert", "openstack-nova-network", "openstack-nova-scheduler", "openstack-nova-novncproxy", "openstack-nova-consoleauth", "libvirtd", "openstack-nova-compute"]:
        ensure => running,
        hasstatus => true,
        enable => true,
        require => Class["nova_control_compute::config"],
        notify => Exec["nova_control_compute_db_sync"],
    }
}
