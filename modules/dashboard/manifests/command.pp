class dashboard::command {
    exec { "dashboard_db_sync":
        command => "/usr/share/openstack-dashboard/manage.py syncdb",
        path => $command_path,
        refreshonly => true,
    }

    exec { "dashboard_iptables":
        command => "mkdir -p /tmp/test/dashboard;
				    iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT;
                    /etc/init.d/iptables save;
                   ",
        path => $command_path,
		creates => "/tmp/test/dashboard",
		require => Service["httpd"],
    }
}
