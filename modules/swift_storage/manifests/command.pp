class swift_storage::command {
    exec { "storage_part":
        command => "python /etc/swift/server_config.py;
                    python /etc/swift/ring_storage.py;
                   ",
        path => $command_path,
        refreshonly => true,
        notify => Service["xinetd", "rsyslog", "openstack-swift-account", "openstack-swift-container", "openstack-swift-object"],

    }
        
    exec { "storage_iptables_log":
        command => "mkdir -p /tmp/test/swift_storage;
                    python /etc/swift/disk_part.py;
                    sh /etc/swift/rsyncd.sh;
                    sh /etc/swift/swift.conf.sh;
                    chown -R swift:swift $storage_base_dir;
                    echo -e \"#swift log config\nlocal1.*\t\t\t/var/log/swift/account.log\nlocal2.*\t\t\t/var/log/swift/container.log\nlocal3.*\t\t\t/var/log/swift/object.log\n\" >> /etc/rsyslog.conf;
                    mkdir -p /var/log/swift/;
                    iptables -I INPUT 1 -p tcp -m multiport --dport 6000:6002,873 -j ACCEPT;
                    /etc/init.d/iptables save",	
        path => $command_path,
        creates => "/tmp/test/swift_storage",
        require => Exec["storage_part"],
    }
}
