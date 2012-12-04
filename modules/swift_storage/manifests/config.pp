class swift_storage::config {
	file { "/etc/swift/swift.conf.sh":
		content => template("swift_storage/swift.conf.sh.erb"),
		owner => 'root',
		group => 'root',
		mode => 655,
		require => Package["openstack-swift-account", "openstack-swift-container", "openstack-swift-object", "rsync", "xinetd", "xfsprogs", "python-keystoneclient", "python-nova", "python-novaclient"],
	}

	file { "/etc/swift/disk_part.py":
		content => template("swift_storage/disk_part.py.erb"),
		owner => 'root',
		group => 'root',
		mode => 655,
		require => File["/etc/swift/swift.conf.sh"],
		notify => Exec["storage_part"],
	}

	file { "/etc/swift/rsyncd.sh":
		content => template("swift_storage/rsyncd.sh.erb"),
		owner => 'root',
		group => 'root',
		mode => 655,
		require => File["/etc/swift/disk_part.py"],
	}
	
	file { "/etc/swift/server_config.py":
		content => template("swift_storage/server_config.py.erb"),
		owner => 'root',
		group => 'root',
		mode => 655,
		require => File["/etc/swift/rsyncd.sh"],
        notify => Exec [ "storage_part" ],
	}
	
	file { "/etc/swift/ring_storage.py":
		content => template("swift_storage/ring_storage.py.erb"),
		owner => 'root',
		group => 'root',
		mode => 655,
		require => File["/etc/swift/server_config.py"],
		notify => Exec["storage_part"],
	}
}
