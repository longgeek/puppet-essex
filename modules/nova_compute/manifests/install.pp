class nova_compute::install {
    package { ["openstack-nova", "libvirt"]:
        ensure => installed,
    }
}
