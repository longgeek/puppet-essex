class mysql::install {
    package { ["mysql", "mysql-server", "mysql-libs"]:
        ensure => installed,
    }
    package { "mysql-devel":
		ensure => installed,
    }
}
