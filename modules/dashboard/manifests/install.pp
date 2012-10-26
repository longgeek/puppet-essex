class dashboard::install {
    package { ["openstack-dashboard", "python-django-horizon", "Django", "python-django-nose", "python-nose", "httpd", "mod_wsgi"]:
        ensure => installed,
		require => Class["$dashboard_require"],
    }
}

