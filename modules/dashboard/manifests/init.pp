class dashboard {

    package { ["openstack-dashboard", "python-django-horizon", "Django", "python-django-nose", "python-nose", "httpd", "mod_wsgi"]:
        ensure => installed,
        notify => File["/etc/openstack-dashboard/local_settings"],
    }

    file { "/etc/openstack-dashboard/local_settings":
        content => template("dashboard/local_settings.erb"),
        mode => 644,
        notify => File["/usr/lib/python2.6/site-packages/horizon/locale/zh_CN/LC_MESSAGES/django.mo"],
    }

    file { "/usr/lib/python2.6/site-packages/horizon/locale/zh_CN/LC_MESSAGES/django.mo":
        source => "puppet:///modules/dashboard/django.mo",
        mode => "0644",
        require => File["/etc/openstack-dashboard/local_settings"],
        notify => Service["httpd"],
    }

    service { "httpd":
        ensure => true,
        hasstatus => true,
        enable => true,
        require => File["/etc/openstack-dashboard/local_settings"],
        notify => Exec["dashboard_db_sync"],
    }

    exec { "dashboard_db_sync":
        command => "/usr/share/openstack-dashboard/manage.py syncdb",
        path => $command_path,
        refreshonly => true,
        notify => Exec["dashboard_iptables"],
    }

    exec { "dashboard_iptables":
        command => "mkdir -p /etc/.openstack/dashboard;
                    iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT;
                    /etc/init.d/iptables save;
                   ",
        path => $command_path,
        creates => "/etc/.openstack/dashboard",
    }
}
