class dashboard::service {
    service { "httpd":
        ensure => true,
        hasstatus => true,
        enable => true,
        require => File["/etc/openstack-dashboard/local_settings"],
        notify => Exec["dashboard_db_sync"],
    }
}


