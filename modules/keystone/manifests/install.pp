class keystone::install {
    package { "openstack-keystone":
        ensure => installed,
    }
}
