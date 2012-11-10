class dashboard::config {
    file { "/etc/openstack-dashboard/local_settings":
        content => template("dashboard/local_settings.erb"),
        owner => "root",
        group => "root",
        mode => 644,
        require => Package["openstack-dashboard", "python-django-horizon", "Django", "python-django-nose", "python-nose", "httpd", "mod_wsgi"],
        notify => Service["httpd"],
    }

	file { "/usr/lib/python2.6/site-packages/horizon/locale/zh_CN/LC_MESSAGES/django.mo":
        source => "puppet:///modules/dashboard/django.mo",
        owner => "root",
        group => "root",
        mode => "0644",
        require => File["/etc/openstack-dashboard/local_settings"],
        notify => Service["httpd"],
	}
}
