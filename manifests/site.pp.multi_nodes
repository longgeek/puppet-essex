##Mode=(auth_file, mysql, keystone, rabbitmq, glance, nova_control_compute, nova_control, nova_compute)

###     Example all-on-one
###     node control.geek.com {
###         include mysqk, keystone, auth_file, rabbitmq, glance, nova_control_compute, dashboard 
###     }
#node default {
#    include mysql
#	include keystone 
#	include	auth_file
#	include rabbitmq
#	include glance
#	include nova_control
#	include dashboard
#}

node 'control.csvt.com' {
	include mysql, keystone, auth_file, rabbitmq, glance, nova_control, dashboard
}

node 'compute1.csvt.com' {
	include nova_compute
}

node 'compute2.csvt.com' {
	include nova_compute
}
node 'test.csvt.com' {
	include rabbitmq#mysql, keystone, auth_file, rabbitmq, glance, nova_control, dashboard
}
##模块执行的顺序依赖关系,例如$keystone_require = ‘mysql::comand'就是说agent执行keystone这个模块的时候需要先执行完mysql::command这个类
##默认模块执行顺序: mysql->keystone->auth_file->glance->rabbitmq,nova_control&nova_control_compute->nova_compute->dashboard->swift_proxy-swift_storage

$keystone_require				= 'mysql::command'
$auth_file_require				= ''
$rabbitmq_require				= ''
$glance_require					= 'rabbitmq'
$nova_control_require			= 'glance::command'
$dashboard_require				= 'nova_control::command'
$nova_control_compute_require	= ''

##base
$command_path                   = '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/bin/bash'
$verbose                        = 'False'
##$debug                         = 'true'

##mysql
$mysql_root_password            = 'mysql'
$keystone_db_password           = 'keystone'
$nova_db_password               = 'nova'
$glance_db_password             = 'glance'
$dash_db_password               = 'dash'

##keystone
$keystone_admin_token           = 'token'
$mysql_host                     = '172.16.0.55'
$keystone_lan_ip                = '172.16.0.55'
$keystone_wlan_ip               = '192.168.3.10'
$glance_host                    = '172.16.0.55'
$swift_proxy_lan_ip             = '172.16.0.55'
$swift_proxy_wlan_ip            = '172.16.0.55'
$ec2_host                       = '172.16.0.55'
$admin_password                 = 'dcloud'
$admin_user                     = 'admin'
$admin_tenant                   = 'DCloud'

##glance
$rabbit_user                    = 'geek1'
$rabbit_password                = 'guest1'
$rabbit_host                    = '172.16.0.55'
$glance_default_store           = 'file'

##nova
$public_interface               = 'eth1'
$flat_interface                 = 'eth0'
$fixed_range                    = '10.0.0.0/24'  
$floating_range                 = '192.168.3.32/27'
$multi_host                     = 'true'
$libvirt_type                   = 'kvm'
$nova_control_host              = '172.16.0.55'
$nova_compute_host              = '192.168.3.11'
$novnc_base_url_ip				= '192.168.3.10'
$network_size                   = '256'

##swift_proxy
$proxy_workers					= '2'
$storage_workers				= '2'
$storage_numbers				= '1'
$storage_node_ip				= '["172.16.0.240"]'
$storage_disk_part				= '["sdb1"]'
$storage_base_dir				= '/swift-storage/'
$ring_part_power				= '18'
$ring_replicas                  = '1'
$ring_min_part_hours			= '1'
$swift_hash_suffix				= 'http://www.longgeek.com'
$memcached_host					= '172.16.0.240'
