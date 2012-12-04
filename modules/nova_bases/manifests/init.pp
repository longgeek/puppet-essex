class nova_bases {
    file { "/root/set_br100.sh":
        content => template("nova_bases/set_br100.sh.erb"),
        owner => "root",
        group => "root",
        mode => 644,
        notify => Exec["set_br100.sh"],
    }

    exec { "set_br100.sh":
        command => "sh /root/set_br100.sh",
        path => $command_path,
        #creates => "/tmp/test/nova_bases",
        require => File["/root/set_br100.sh"],
        refreshonly => true,
    }
}
