class glance::install {
    package { ["openstack-glance", "python-glance"]:
        ensure => installed,
    }
}
