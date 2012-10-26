#注意：这个site.pp只适用于单节点部署,需要多节点部署请修改site.pp.multi_nodes

####一.配置节点

###     Example all-on-one
#
#主机名： www.longgeek.com
#ip地址： 172.16.0.11
#

node 'www.longgeek.com' {
    include mysql, keystone, auth_file, glance, rabbitmq, nova_control_compute, dashboard, swift_proxy, swift_storage
}

######################################################################################################################
######################################################################################################################

####二.全局变量

##模块执行的顺序依赖关系,例如$keystone_require = ‘mysql::comand'就是说agent执行keystone这个模块的时候需要先执行完mysql::command这个类
##默认模块执行顺序: mysql -> keystone -> auth_file -> glance -> rabbitmq -> nova_control&nova_control_compute -> nova_compute -> dashboard -> swift_proxy -> swift_storage

$keystone_require               = 'mysql::command'
$auth_file_require              = 'keystone::command'
$glance_require                 = 'auth_file'
$rabbitmq_require               = 'glance::command'
$nova_control_compute_require   = 'rabbitmq'
$dashboard_require              = 'nova_control_compute::command'
$swift_proxy_require            = 'dashboard::command'
$swift_storage_require          = 'swift_proxy::command'

## Base -------------------------------------------------------------------------------------------------------------
$command_path                   = '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/bin/bash'
$verbose                        = 'False'
$all_on_one_ip                  = '172.16.0.11'

## Mysql -------------------------------------------------------------------------------------------------------------
$mysql_root_password            = 'mysql'
$keystone_db_password           = 'keystone'
$nova_db_password               = 'nova'
$glance_db_password             = 'glance'
$dash_db_password               = 'dash'

## Keystone ----------------------------------------------------------------------------------------------------------
$keystone_admin_token           = 'token'
$mysql_host                     = $all_on_one_ip
$keystone_lan_ip                = $all_on_one_ip
$keystone_wlan_ip               = $all_on_one_ip
$glance_host                    = $all_on_one_ip
$swift_proxy_lan_ip             = $all_on_one_ip
$swift_proxy_wlan_ip            = $all_on_one_ip
$ec2_host                       = $all_on_one_ip
$admin_password                 = '123456'
$admin_user                     = 'admin'
$admin_tenant                   = 'openstack'

## Glance ------------------------------------------------------------------------------------------------------------
$rabbit_user                    = 'guest'
$rabbit_password                = 'guest'
$rabbit_host                    = $all_on_one_ip
$glance_default_store           = 'file'

## Nova --------------------------------------------------------------------------------------------------------------
$public_interface               = 'eth0'      #双网卡可以改为eth1
$flat_interface                 = 'eth0'
$fixed_range                    = '10.0.0.0/24'  
$floating_range                 = '172.16.0.32/27'
$multi_host                     = 'false'
$libvirt_type                   = 'kvm'
$nova_control_host              = $all_on_one_ip
$nova_compute_host              = $all_on_one_ip
$novnc_base_url_ip              = $all_on_one_ip
$network_size                   = '256'

## Swift -------------------------------------------------------------------------------------------------------------
$proxy_workers                  = '2'
$storage_workers                = '2'
$storage_numbers                = '1'
$storage_node_ip                = "[\"$all_on_one_ip\"]"
$storage_disk_part              = '["sda5"]'  #根据实际情况来指定分区，确保有剩余空间
$storage_base_dir               = '/swift-storage/'
$ring_part_power                = '18'
$ring_replicas                  = '1'
$ring_min_part_hours            = '1'
$swift_hash_suffix              = 'http://www.longgeek.com'
$memcached_host                 = $all_on_one_ip
