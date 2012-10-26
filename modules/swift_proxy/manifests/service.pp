class swift_proxy::service{
	service { "openstack-swift-proxy":
		ensure => running,
		hasstatus => true,
		enable => true,
		require => Exec["ring"],
	}	
}
