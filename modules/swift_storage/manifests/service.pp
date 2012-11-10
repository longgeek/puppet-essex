class swift_storage::service {
    service { ["xinetd", "rsyslog", "openstack-swift-account", "openstack-swift-container", "openstack-swift-object"]:
        ensure => running,
        hasstatus => true,
        enable => true,
        require => Exec["storage_part"],
	}
}
