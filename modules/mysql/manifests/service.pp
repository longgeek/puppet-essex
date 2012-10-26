class mysql::service {
    service { "mysqld":
        ensure => running,
        hasstatus => true,
        enable => true,
        require => Package["mysql", "mysql-server", "mysql-libs", "mysql-devel"],
    }
}
