####一.配置节点

###     Example all-on-one
#
#主机名： www.longgeek.com
#ip地址： 172.16.0.21
#

node 'control1.csvt.com' {
    include mysql, keystone, auth_file, glance, rabbitmq, nova_control_compute, dashboard, nova_bases , swift_proxy
}
#
node 'compute2.csvt.com' {
    $nova_bases_require = ''
    include nova_bases,nova_compute, swift_storage#, nova_bases#, swift_storage
}
node 'compute3.csvt.com' {
    $nova_bases_require = ''
    include nova_bases,nova_compute, swift_storage#, nova_bases#, swift_storage
}

node 'compute4.csvt.com' {
    $nova_bases_require = ''
    include nova_bases,nova_compute,swift_storage#, nova_bases#, swift_storage
}

#
######################################################################################################################
######################################################################################################################

####二.全局变量

##模块执行的顺序依赖关系,例如$keystone_require = ‘mysql::comand'就是说agent执行keystone这个模块的时候需要先执行完mysql::command这个类
##默认模块执行顺序: mysql -> keystone -> auth_file -> glance -> rabbitmq -> nova_control&nova_control_compute -> nova_compute -> dashboard -> swift_proxy -> swift_storage

$keystone_require               = 'mysql::command'
$auth_file_require              = 'keystone::command'
$glance_require                 = 'auth_file'
$rabbitmq_require               = 'glance::command'
$nova_control_require           = 'rabbitmq'
$nova_control_compute_require	= 'rabbitmq'
$nova_bases_require             = 'nova_control_compute::command'
$dashboard_require              = 'nova_control_compute::command'
$swift_proxy_require            = 'dashboard::command'
$swift_storage_require          = 'nova_compute::command'

#$keystone_require               = ''
#$auth_file_require              = ''
#$glance_require                 = ''
#$rabbitmq_require               = ''
#$nova_control_require			= ''
#$dashboard_require              = ''
#$swift_proxy_require            = ''
#$swift_storage_require          = ''
## Base -------------------------------------------------------------------------------------------------------------
$command_path                   = '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/bin/bash'
$verbose                        = 'True'

## Mysql -------------------------------------------------------------------------------------------------------------
$mysql_root_password            = 'mysql'
$keystone_db_password           = 'keystone'
$nova_db_password               = 'nova'
$glance_db_password             = 'glance'
$dash_db_password               = 'dash'

## Keystone ----------------------------------------------------------------------------------------------------------
$keystone_admin_token           = 'token'
$mysql_host                     = '172.16.0.21'
$keystone_lan_ip                = '172.16.0.21'
$keystone_wlan_ip               = '172.16.0.21'
$glance_host                    = '172.16.0.21'
$swift_proxy_lan_ip             = '172.16.0.21'
$swift_proxy_wlan_ip            = '172.16.0.21'
$ec2_host                       = '172.16.0.21'
$admin_password                 = 'password'
$admin_user                     = 'admin'
$admin_tenant                   = 'admin'

## Glance ------------------------------------------------------------------------------------------------------------
$rabbit_user                    = 'guest'
$rabbit_password                = 'guest'
$rabbit_host                    = '172.16.0.21'
$glance_default_store           = 'file'

## Nova --------------------------------------------------------------------------------------------------------------
$public_interface               = 'eth0' 
$flat_interface                 = 'eth0'
$fixed_range                    = '10.0.0.0/24'
$floating_range                 = '172.16.0.32/27'
$multi_host                     = 'true'
$libvirt_type                   = 'kvm'
$nova_control_host              = '172.16.0.21'
$nova_compute_host              = '172.16.0.21'
$novnc_base_url_ip              = '172.16.0.21'
$network_size                   = '256'

## Swift -------------------------------------------------------------------------------------------------------------
$proxy_workers                  = '2'
$storage_workers                = '2'
$storage_numbers                = '3'
$storage_node_ip                = '["172.16.0.22", "172.16.0.23", "172.16.0.24"]'
$storage_disk_part              = '["sdb1"]'  #根据实际情况来指定分区，确保有剩余空间
$storage_base_dir               = '/swift-storage/'
$ring_part_power                = '18'
$ring_replicas                  = '3'
$ring_min_part_hours            = '1'
$swift_hash_suffix              = 'http://www.longgeek.com'
$memcached_host                 = '172.16.0.21'
