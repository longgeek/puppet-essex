class nova_control::install {
    package { ["openstack-nova", "openstack-nova-novncproxy"]:
        ensure => installed,
    }
}
