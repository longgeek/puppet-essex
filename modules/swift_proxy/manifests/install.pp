class swift_proxy::install {
    package { ["openstack-swift", "openstack-swift-proxy", "vsftpd"]:
		ensure => installed,
		require => Class["$swift_proxy_require"],
    }
}
