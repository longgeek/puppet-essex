class rabbitmq {
    package { "rabbitmq-server":
        ensure => installed,
        notify => Service["rabbitmq-server"],
    }

    service { "rabbitmq-server":
        ensure => running,
        hasstatus => true,
        enable => true,
        notify => Exec["rabbitmq_user"],
    }

    exec { "rabbitmq_user":
        command => "rabbitmqctl list_users | grep $rabbit_user > /dev/null 2>&1;
                    if [ `echo $?` != 0 ]; then rabbitmqctl add_user $rabbit_user $rabbit_password; rabbitmqctl set_user_tags $rabbit_user administrator; else rabbitmqctl change_password $rabbit_user $rabbit_password; fi; 
                   ",
        path => $command_path,
        refreshonly => true,
        notify => Exec["rabbitmq_iptables"],

    }

    exec { "rabbitmq_iptables":
        command => "mkdir -p /etc/.openstack/rabbitmq;
                    iptables -I INPUT -p tcp --dport 5672 -j ACCEPT;
                    /etc/init.d/iptables save",
        path => $command_path,
        creates => "/etc/.openstack/rabbitmq",
    }
}
