class nova_compute {

    package { ["openstack-nova", "libvirt"]:
        ensure => installed,
        notify => File["/etc/nova/nova.conf.sh"],
    }

    file { "/etc/nova/nova.conf.sh":
        content => template("nova_compute/nova.conf.sh.erb"),
        group => "nova",
        mode => 644,
        notify => File["/etc/nova/api-paste.ini"],
    }

    file { "/etc/nova/api-paste.ini":
        content => template("nova_compute/api-paste.ini.erb"),
        group => "nova",
        mode => 644,
        notify => File["/etc/libvirt/nwfilter/nova-base.xml"],
    }

    file { "/etc/libvirt/nwfilter/nova-base.xml":
        source => "puppet:///modules/nova_compute/nova-base.xml",
        mode => 600,
        notify => File["/etc/libvirt/nwfilter/nova-vpn.xml"],
    }

    file { "/etc/libvirt/nwfilter/nova-vpn.xml":
        source => "puppet:///modules/nova_compute/nova-vpn.xml",
        mode => 600,
        notify => File["/etc/libvirt/nwfilter/nova-allow-dhcp-server.xml"],
    }

    file { "/etc/libvirt/nwfilter/nova-allow-dhcp-server.xml":
        source => "puppet:///modules/nova_compute/nova-allow-dhcp-server.xml",
        mode => 600,
        notify => Service["openstack-nova-network", "libvirtd", "openstack-nova-compute", "rpcbind", "openstack-nova-metadata-api"],
    }

    service { ["openstack-nova-network", "libvirtd", "openstack-nova-compute", "rpcbind", "openstack-nova-metadata-api"]:
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        enable => true,
        notify => Exec["nova_conf"],
    }

    exec { "nova_conf":
        command => "sh /etc/nova/nova.conf.sh",
        path => $command_path,
        refreshonly => true,
        notify => Exec["nova_db_sync"],
    }

    exec { "nova_db_sync":
        command => "nova-manage db sync",
        path => $command_path,
        refreshonly => true,
        notify => Exec["nova_iptables"],
    }

    exec { "nova_iptables":
        command => "mkdir -p /etc/.openstack/nova_compute;
                    iptables -I INPUT 1 -p tcp -m multiport --dport 5900:6200,53 -j ACCEPT;
                    iptables -I INPUT 1 -p udp -m multiport --dport 53,67 -j ACCEPT;
                    iptables -t filter -N nova-compute-FORWARD;
                    iptables -t filter -N nova-compute-INPUT;
                    iptables -t filter -N nova-compute-OUTPUT;
                    iptables -t filter -N nova-compute-inst;
                    iptables -t filter -N nova-compute-local;
                    iptables -t filter -N nova-compute-provider;
                    iptables -t filter -N nova-compute-sg-fallback;
                    iptables -t filter -A INPUT -j nova-compute-INPUT;
                    iptables -t filter -A FORWARD -j nova-compute-FORWARD;
                    iptables -t filter -A OUTPUT -j nova-compute-OUTPUT;
                    iptables -t filter -A nova-compute-sg-fallback -j DROP;
                    iptables -t filter -A nova-filter-top -j nova-compute-local;
                    iptables -t filter -A nova-network-FORWARD -i br100 -j ACCEPT;
                    iptables -t filter -A nova-network-FORWARD -o br100 -j ACCEPT;
                    iptables -t filter -A nova-network-INPUT -i br100 -p udp -m udp --dport 67 -j ACCEPT;
                    iptables -t filter -A nova-network-INPUT -i br100 -p tcp -m tcp --dport 67 -j ACCEPT;
                    iptables -t filter -A nova-network-INPUT -i br100 -p udp -m udp --dport 53 -j ACCEPT;
                    iptables -t filter -A nova-network-INPUT -i br100 -p tcp -m tcp --dport 53 -j ACCEPT;
                    iptables -t nat -N nova-compute-OUTPUT;
                    iptables -t nat -N nova-compute-POSTROUTING;
                    iptables -t nat -N nova-compute-PREROUTING;
                    iptables -t nat -N nova-compute-float-snat;
                    iptables -t nat -N nova-compute-snat;
                    iptables -t nat -A PREROUTING -j nova-compute-PREROUTING;
                    iptables -t nat -A POSTROUTING -j nova-compute-POSTROUTING;
                    iptables -t nat -A OUTPUT -j nova-compute-OUTPUT;
                    iptables -t nat -A nova-compute-snat -j nova-compute-float-snat;
                    iptables -t nat -A nova-postrouting-bottom -j nova-compute-snat;
                    /etc/init.d/iptables save;
                   ",
        path => $command_path,
        creates => "/etc/.openstack/nova_compute",
        require => Exec["nova_db_sync"],
    }
}
