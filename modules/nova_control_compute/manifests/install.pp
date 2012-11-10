class nova_control_compute::install {
    package { ["openstack-nova", "openstack-nova-novncproxy", "libvirt"]:
        ensure => installed,
        require => Class["$nova_control_compute_require"],
    }
}
