class pym_client {
    package { ["pym_client", "python-paramiko", "pyssh"]:
        ensure => installed,
        notify => File["/etc/pymonitor/pym_client.conf"],
    }

    file { "/etc/pymonitor/pym_client.conf":
        content => template("pym_server/pym_client.conf.erb"),
        notify => Service["pym_client"],
    }

    service { ["pym_client"]:
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        enable => true,
    }
}
