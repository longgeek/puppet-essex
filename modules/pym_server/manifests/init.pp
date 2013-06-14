class pym_server {
    package { ["pym_server", "pym_client", "redis", "python-redis", "python-paramiko", "pyssh"]:
        ensure => installed,
        notify => File["/etc/pymonitor/pym_api-$pym_api_version.tar.gz"],
    }

    file { "/etc/pymonitor/pym_api-$pym_api_version.tar.gz":
        source => "puppet:///modules/pym_server/pym_api-$pym_api_version.tar.gz",
        notify => File["/etc/pymonitor/pym_server.conf"],
    }

    file { "/etc/pymonitor/pym_server.conf":
        content => template("pym_server/pym_server.conf.erb"),
        notify => File["/etc/pymonitor/pym_client.conf"],
    }

    file { "/etc/pymonitor/pym_client.conf":
        content => template("pym_server/pym_client.conf.erb"),
        notify => Exec["tar zxvf pym_api"],
    }

    exec { "tar zxvf pym_api":
        command => "tar zxvf pym_api-$pym_api_version.tar.gz",
        cwd => "/etc/pymonitor",
        path => $command_path,
        subscribe => File["/etc/pymonitor/pym_api-$pym_api_version.tar.gz"],
        refreshonly => true,
        notify => Exec["python setup.py"],
    }

    exec { "python setup.py":
        command => "python setup.py install",
        cwd => "/etc/pymonitor/pym_api-$pym_api_version",
        path => $command_path,
        subscribe => Exec["tar zxvf pym_api"],
        refreshonly => true,
        notify => Exec["pym iptables"],
    }

    exec { "pym iptables":
        command => "iptables -I INPUT 1 -p tcp --dport 8123 -j ACCEPT;
                    iptables -I INPUT 1 -p tcp --dport 6379 -j ACCEPT;
                    /etc/init.d/iptables save;
                    mkdir -p /etc/.openstack/pym_iptables",
        path => $command_path,
        creates => "/etc/.openstack/pym_iptables",
        notify => Service["redis", "pym_server", "pym_client"],
    }

    service { ["redis", "pym_server", "pym_client"]:
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        enable => true,
    }
}
