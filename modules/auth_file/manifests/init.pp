class auth_file {
    file { '/root/openrc':
        content =>
           "
export OS_TENANT_NAME=${admin_tenant}
export OS_USERNAME=${admin_user}
export OS_PASSWORD=${admin_password}
export OS_AUTH_URL=\"http://${keystone_lan_ip}:5000/v2.0/\"
export OS_AUTH_STRATEGY=keystone
export SERVICE_TOKEN=${keystone_admin_token}
export SERVICE_ENDPOINT=http://${keystone_lan_ip}:35357/v2.0/
            ",
		require => Class["$auth_file_require"],
        notify => Exec["source_openrc"],
    }

    exec {"source_openrc":
        command => "echo 'source /root/openrc' >> /etc/profile; source /etc/profile",
        path => $command_path,
        refreshonly => true,
    }
}
