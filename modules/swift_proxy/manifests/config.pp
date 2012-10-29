class swift_proxy::config {
	file { "/etc/swift/swift.conf":
		content => template("swift_proxy/swift.conf.erb"),
		owner => 'root',
		group => 'root',
		mode => 644,
		require => Package["openstack-swift", "openstack-swift-proxy"],
	
	}

	file { "/etc/swift/proxy-server/proxy-server.conf":
		content => template("swift_proxy/proxy-server.conf.erb"),	
		owner => 'root',
		group => 'root',
		mode => 644,
		require => File["/etc/swift/swift.conf"],
	}

	file { "/etc/swift/ring.py":
		content => template("swift_proxy/ring.py.erb"),
		owner => 'root',
		group => 'root',
		mode => '655',
		require => File["/etc/swift/proxy-server/proxy-server.conf"],
		notify => Exec["ring"],
	}
}
