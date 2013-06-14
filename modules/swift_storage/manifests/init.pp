class swift_storage {

    package { ["openstack-swift-account", "openstack-swift-container", "openstack-swift-object", "rsync", "xinetd", "xfsprogs", "python-keystoneclient", "python-nova", "python-novaclient"]:
        ensure => installed,
        notify => File["/etc/swift/swift.conf.sh"],
    }

    file { "/etc/swift/swift.conf.sh":
        content => template("swift_storage/swift.conf.sh.erb"),
        mode => 655,
        notify => File["/etc/swift/disk_part.py"],
    }

    file { "/etc/swift/disk_part.py":
        content => template("swift_storage/disk_part.py.erb"),
        mode => 655,
        notify => File["/etc/swift/rsyncd.sh"]
    }

    file { "/etc/swift/rsyncd.sh":
        content => template("swift_storage/rsyncd.sh.erb"),
        mode => 655,
        notify => File["/etc/swift/server_config.py"],
    }
    
    file { "/etc/swift/server_config.py":
        content => template("swift_storage/server_config.py.erb"),
        mode => 655,
        notify => File["/etc/swift/ring_storage.py"],
    }
    
    file { "/etc/swift/ring_storage.py":
        content => template("swift_storage/ring_storage.py.erb"),
        mode => 655,
        notify => Exec["storage_part"],
    }

    exec { "storage_part":
        command => "python /etc/swift/server_config.py;
                    python /etc/swift/ring_storage.py;
                   ",
        path => $command_path,
        refreshonly => true,
        notify => Exec["storage_iptables_log"],
        
    }
        
    exec { "storage_iptables_log":
        command => "mkdir -p /etc/.openstack/swift_storage;
                    python /etc/swift/disk_part.py;
                    sh /etc/swift/rsyncd.sh;
                    sh /etc/swift/swift.conf.sh;
                    chown -R swift:swift $storage_base_dir;
                    echo -e \"#swift log config\nlocal1.*\t\t\t/var/log/swift/account.log\nlocal2.*\t\t\t/var/log/swift/container.log\nlocal3.*\t\t\t/var/log/swift/object.log\n\" >> /etc/rsyslog.conf;
                    mkdir -p /var/log/swift/;
                    iptables -I INPUT 1 -p tcp -m multiport --dport 6000:6002,873 -j ACCEPT;
                    /etc/init.d/iptables save",    
        path => $command_path,
        creates => "/etc/.openstack/swift_storage",
        notify => Service["xinetd", "rsyslog", "openstack-swift-account", "openstack-swift-container", "openstack-swift-object"],
    }

    service { ["xinetd", "rsyslog", "openstack-swift-account", "openstack-swift-container", "openstack-swift-object"]:
        ensure => running,
        hasstatus => true,
        enable => true,
    }
}
