class mysql::config {
    file { "/etc/my.cnf":
        source => "puppet:///modules/mysql/my.cnf",
        owner => "mysql",
        group => "mysql",
        mode => 0600,
        require => Package["mysql", "mysql-server", "mysql-libs", "mysql-devel"],
        notify => Service["mysqld"],
    }
}
