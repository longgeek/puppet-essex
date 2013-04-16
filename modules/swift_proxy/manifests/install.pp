class swift_proxy::install {
    package { ["openstack-swift", "openstack-swift-proxy"]:
        ensure => installed,
    }
}
