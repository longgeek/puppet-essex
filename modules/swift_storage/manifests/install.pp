class swift_storage::install {
	package { ["openstack-swift-account", "openstack-swift-container", "openstack-swift-object", "rsync", "xinetd", "xfsprogs", "python-keystoneclient", "python-nova", "python-novaclient"]:
        ensure => installed,
	}
}
