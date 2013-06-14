class nova_control_compute {

    package { ["openstack-nova", "openstack-nova-novncproxy", "libvirt"]:
        ensure => installed,
        notify => File["/etc/nova/nova.conf"],
    }

    file { "/etc/nova/nova.conf":
        content => template("nova_control_compute/nova.conf.erb"),
        group => "nova",
        mode => 644,
        notify => File["/etc/nova/api-paste.ini"],
    }

    file { "/etc/nova/api-paste.ini":
        content => template("nova_control_compute/api-paste.ini.erb"),
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
        notify => File["/etc/nova/create-nova-volumes.py"],
    }

    file { "/etc/nova/create-nova-volumes.py":
        content => template("nova_control_compute/create-nova-volumes.py.erb"),
        mode => 755,
        notify => Exec["python create-nova-volumes.py"],
    }

    exec { "python create-nova-volumes.py":
        command => "python /etc/nova/create-nova-volumes.py",
        path => $command_path,
        subscribe => File["/etc/nova/create-nova-volumes.py"],
        refreshonly => true,
        notify => Service["openstack-nova-api", "openstack-nova-cert", "openstack-nova-network", "openstack-nova-scheduler", "openstack-nova-novncproxy", "openstack-nova-consoleauth", "libvirtd", "openstack-nova-compute", "openstack-nova-volume", "tgtd", "rpcbind"],
        
    }

    service { ["openstack-nova-api", "openstack-nova-cert", "openstack-nova-network", "openstack-nova-scheduler", "openstack-nova-novncproxy", "openstack-nova-consoleauth", "libvirtd", "openstack-nova-compute", "openstack-nova-volume", "tgtd", "rpcbind"]:
        ensure => running,
        hasstatus => true,
        enable => true,
        notify => Exec["nova_control_compute_db_sync"],
    }

    exec { "nova_control_compute_db_sync":
        command => "nova-manage db sync;
                    nova-manage network create private --fixed_range_v4=$fixed_range --num_netwroks=1 --bridge=br100 --bridge_interface=$flat_interface --network_size=$network_size --multi_host=T;
                    nova-manage floating create --ip_range=$floating_range --interface=$public_interface;
                    mkdir -p /etc/.openstack/nova_control_compute_db_sync",
        path => $command_path,
        creates => "/etc/.openstack/nova_control_compute_db_sync",
        notify => Exec["nova_control_compute_iptables"],
    }

    exec { "nova_control_compute_iptables":
        command => "mkdir -p /etc/.openstack/nova_control_compute;
                    iptables -I INPUT 1 -p tcp -m multiport --dport 8773:8776,6080,5900:6200 -j ACCEPT;
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
                    source /etc/profile;
                    nova secgroup-add-rule default tcp 22 22 0.0.0.0/0;
                    nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0;
                    ",
        path => $command_path,
        creates => "/etc/.openstack/nova_control_compute",
    }
}
