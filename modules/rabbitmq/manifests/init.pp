class rabbitmq {
    package { "rabbitmq-server":
        ensure => installed,
        require => Class["$rabbitmq_require"],
    }

    service { "rabbitmq-server":
        ensure => running,
        hasstatus => true,
        enable => true,
        require => Package["rabbitmq-server"],
        notify => Exec["rabbitmq_user"],
    }

	exec { "rabbitmq_user":
        command => "rabbitmqctl list_users | grep $rabbit_user > /dev/null 2>&1;
                    if [ `echo $?` != 0 ]; then rabbitmqctl add_user $rabbit_user $rabbit_password; rabbitmqctl set_user_tags $rabbit_user administrator; else rabbitmqctl change_password $rabbit_user $rabbit_password; fi; 
                   ",
        path => $command_path,
        require => Service["rabbitmq-server"],
        refreshonly => true,

	}

    exec { "rabbitmq_iptables":
        command => "mkdir -p /tmp/test/rabbitmq;
                    iptables -I INPUT -p tcp --dport 5672 -j ACCEPT;
                    /etc/init.d/iptables save",
        path => $command_path,
		creates => "/tmp/test/rabbitmq",
		require => Service["rabbitmq-server"],
    }
}
