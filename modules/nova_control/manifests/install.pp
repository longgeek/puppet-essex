class nova_control::install {
    package { ["openstack-nova", "openstack-nova-novncproxy"]:
        ensure => installed,
		require => Class["$nova_control_require"],
    }
}
