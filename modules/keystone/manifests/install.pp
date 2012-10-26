class keystone::install {
    package { "openstack-keystone":
        ensure => installed,
		require => Class["$keystone_require"],
    }
}
