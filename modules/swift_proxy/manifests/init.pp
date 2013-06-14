class swift_proxy {

    package { ["openstack-swift", "openstack-swift-proxy"]:
        ensure => installed,
        notify => File["/etc/swift/swift.conf"],
    }

    file { "/etc/swift/swift.conf":
        content => template("swift_proxy/swift.conf.erb"),
        mode => 644,
        notify => File["/etc/swift/proxy-server/proxy-server.conf"],
    
    }

    file { "/etc/swift/proxy-server/proxy-server.conf":
        content => template("swift_proxy/proxy-server.conf.erb"),    
        mode => 644,
        notify => File["/etc/swift/ring.py"],
    }

    file { "/etc/swift/ring.py":
        content => template("swift_proxy/ring.py.erb"),
        mode => '655',
        require => File["/etc/swift/proxy-server/proxy-server.conf"],
        notify => Exec["ring"],
    }

    exec { "ring":
        command => 'python /etc/swift/ring.py',
        path => $command_path,
        refreshonly => true,
        notify => Service["openstack-swift-proxy"],
    }

    service { "openstack-swift-proxy":
        ensure => running,
        hasstatus => true,
        enable => true,
        notify => Exec["proxy_iptables_log"],
    }    

    exec { "proxy_iptables_log":
        command => 'mkdir -p /etc/.openstack/swift_proxy;
                    echo -e "local1.*\t\t\t/var/log/swift/proxy.log" >> /etc/rsyslog.conf;
                    mkdir -p /var/log/swift/;
                    /etc/init.d/rsyslog restart; chkconfig rsyslog on;
                    iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT;
                    iptables -I INPUT 1 -p tcp --dport 21 -j ACCEPT;
                    /etc/init.d/iptables save;
                    ',
        path => $command_path,
        creates => "/etc/.openstack/swift_proxy",
        #echo -e "pasv_min_port=20000\npasv_max_port=21000" >> /etc/vsftpd/vsftpd.conf;
        #iptables -I INPUT 1 -p tcp --dport 20000:21000 -j ACCEPT;
        #/etc/init.d/vsftpd start;
        #chkconfig vsftpd on;
    }
}
