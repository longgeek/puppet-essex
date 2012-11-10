class swift_proxy::command {
	exec { "ring":
		command => 'python /etc/swift/ring.py',
		path => $command_path,
		refreshonly => true,
		notify => Service["openstack-swift-proxy"],
	}

	exec { "proxy_iptables_log":
		command => 'mkdir -p /tmp/test/swift_proxy;
					echo -e "local1.*\t\t\t/var/log/swift/proxy.log" >> /etc/rsyslog.conf;
					mkdir -p /var/log/swift/;
					/etc/init.d/rsyslog restart; chkconfig rsyslog on;
					iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT;
					iptables -I INPUT 1 -p tcp --dport 21 -j ACCEPT;
					/etc/init.d/iptables save;
					',
		path => $command_path,
		creates => "/tmp/test/swift_proxy",
		require => Exec["ring"],
					#echo -e "pasv_min_port=20000\npasv_max_port=21000" >> /etc/vsftpd/vsftpd.conf;
					#iptables -I INPUT 1 -p tcp --dport 20000:21000 -j ACCEPT;
					#/etc/init.d/vsftpd start;
					#chkconfig vsftpd on;
	}
}
