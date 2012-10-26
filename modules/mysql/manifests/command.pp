class mysql::command {
    exec { "create-databases":
        command => "mysqladmin -uroot password ${mysql_root_password};
         mysql -uroot -p${mysql_root_password} -e \"create database keystone;\";
         mysql -uroot -p${mysql_root_password} -e \"create database nova;\";
         mysql -uroot -p${mysql_root_password} -e \"create database glance;\"; 
         mysql -uroot -p${mysql_root_password} -e \"create database dash;\";
         mysql -uroot -p${mysql_root_password} -e \"grant all on nova.* to 'nova'@'%' identified by '${nova_db_password}';\";
         mysql -uroot -p${mysql_root_password} -e \"grant all on dash.* to 'dash'@'%' identified by '${dash_db_password}';\";
         mysql -uroot -p${mysql_root_password} -e \"grant all on glance.* to 'glance'@'%' identified by '${glance_db_password}';\";
         mysql -uroot -p${mysql_root_password} -e \"grant all on keystone.* to 'keystone'@'%' identified by '${keystone_db_password}';\"
         iptables -I INPUT 1 -p tcp --dport 3306 -j ACCEPT;
         /etc/init.d/iptables save",
        path => "${$command_path}",
		onlyif => "mysqladmin -uroot  status",
		require => Service["mysqld"],
    }
}
