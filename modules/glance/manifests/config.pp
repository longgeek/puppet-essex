class glance::config {
    file { "/etc/glance/glance-api.conf":
        content => template("glance/glance-api.conf.erb"), 
        owner => "root",
        group => "glance",
        mode => 644,
        require => Package["openstack-glance", "python-glance"],
        notify => Service["openstack-glance-api"],
    }
    
    file { "/etc/glance/glance-api-paste.ini":
        content => template("glance/glance-api-paste.ini.erb"),
        owner => "root",
        group => "glance",
        mode => 644,
        require => File["/etc/glance/glance-api.conf"],
        notify => Service["openstack-glance-api"],
    }

    file { "/etc/glance/glance-registry.conf":
        content => template("glance/glance-registry.conf.erb"),
        owner => "root",
        group => "glance",
        mode => 644,
        require => File["/etc/glance/glance-api-paste.ini"],
        notify => Service["openstack-glance-registry"],
    }

    file { "/etc/glance/glance-registry-paste.ini":
        content => template("glance/glance-registry-paste.ini.erb"),
        owner => "root",
        group => "glance",
        mode => 644,
		require => File["/etc/glance/glance-registry.conf"],
        notify => Service["openstack-glance-registry"],
    }
	file { "/etc/glance/cirros.img":
		source => "puppet:///modules/glance/cirros.img",
		owner => "root",
		group => "root",
		mode => 0644,
		require => File["/etc/glance/glance-registry-paste.ini"],
        notify => Service["openstack-glance-registry"],
	}
}
