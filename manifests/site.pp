#### 一.安装节点所需模块服务

## 控制节点示例：
node 'control.local.com' {
    Class["mysql"] -> Class["keystone"] -> Class["auth_file"] -> Class["glance"] -> Class["rabbitmq"] -> Class["nova_control"] -> Class["dashboard"] -> Class["nova_bases"] -> Class["pym_server"] -> Class["swift_proxy"]
    include mysql, keystone, auth_file, glance, rabbitmq, nova_control, dashboard, nova_bases, pym_server, swift_proxy
}

## 计算节点示例：
node 'compute21.local.com' {
    Class["nova_bases"] -> Class["nova_compute"] -> Class["pym_client"} -> Class["swift_storage"]
    include nova_bases, nova_compute, pym_client, swift_storage
}

node 'compute22.local.com' {
    Class["nova_bases"] -> Class["nova_compute"] -> Class["pym_client"} -> Class["swift_storage"]
    include nova_bases, nova_compute, pym_client, swift_storage
}

####二.全局变量

## Base ------------------------------------------      --------------------------------------------------------------------
$command_path                   = '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/bin/bash'
$verbose                        = 'True'
$all_on_one_ip                  = '172.16.0.20'         # 控制节点管理网络 IP

## Mysql -----------------------------------------      --------------------------------------------------------------------
$mysql_root_password            = 'mysql'               # mysql root 用户密码
$keystone_db_password           = 'keystone'            # keystone 数据库密码
$nova_db_password               = 'nova'                # nova 数据库密码
$glance_db_password             = 'glance'              # glance 数据库密码
$dash_db_password               = 'dash'                # dash 数据库密码

## Keystone --------------------------------------      --------------------------------------------------------------------
$keystone_admin_token           = 'http://www.infu.com.cn'   # keystone token
$mysql_host                     = $all_on_one_ip
$keystone_lan_ip                = $all_on_one_ip
$keystone_wlan_ip               = $all_on_one_ip
$glance_host                    = $all_on_one_ip
$swift_proxy_lan_ip             = $all_on_one_ip
$swift_proxy_wlan_ip            = $all_on_one_ip
$ec2_host                       = $all_on_one_ip
$admin_tenant                   = 'DCloud'              # 管理租户名
$admin_user                     = 'admin'               # 管理用户名
$admin_password                 = 'password'            # 管理用户密码

## Glance ----------------------------------------      --------------------------------------------------------------------
$rabbit_user                    = 'guest'               # rabbitmq 默认用户 guest，无需更改
$rabbit_password                = 'guest'               # rabbitmq 默认密码 guest，无需更改
$rabbit_host                    = $all_on_one_ip
$glance_default_store           = 'file'

## Nova ------------------------------------------      --------------------------------------------------------------------
$public_interface               = 'eth1'                # 公网网络接口
$public_gateway                 = '192.168.8.1'         # 公网网络的网关
$public_netmask                 = '255.255.255.0'       # 公网网络的子网掩码
$public_dns                     = '8.8.8.8'             # 公网网络的 DNS
$flat_interface                 = 'eth0'                # 管理网络接口
$fixed_range                    = '10.0.0.0/8'          # 虚拟机使用的网络
$floating_range                 = '192.168.8.32/27'     # 浮动IP池，公网网络
$multi_host                     = 'true'                # 多网络节点
$libvirt_type                   = 'qemu'                # 使用虚拟机测试 DCloud 时候这里类型为'qemu'，用物理机部署时改为'kvm'
$nova_control_host              = $all_on_one_ip
$novnc_base_url_ip              = '192.168.8.20'        # 控制节点的外网接口 IP 地址
$network_size                   = '65535'

## Volume ----------------------------------------      --------------------------------------------------------------------
$nova_volume_format             = "disk"                # 默认为 'file', 用文件来模拟分区, 设置为 'file'是依赖 '$nova_volume_size'
                                                        # 设置为 'disk'时，依赖 '$nova_volume_disk_part’
$nova_volume_size               = "2G"                  # 使用 file 的话需要指定大小, 必须有单位
$nova_volume_disk_part          = "['sdb1', 'sdc1']"            # 指定 nova 使用哪些硬盘分区, 例如: "['sdb1', 'sdc1', 'sdd1']"

## Swift -----------------------------------------      --------------------------------------------------------------------
$proxy_workers                  = '2'                   # swift proxy 节点 CPU 核数
$storage_workers                = '2'                   # swift storage 节点 CPU 核数
$storage_numbers                = '1'                   # swift storage 节点数量
$storage_node_ip                = '["172.16.0.21", "172.16.0.22"]'     # swift storage 所有节点的 IP 地址,多个例如 '["172.16.0.20", "172.16.0.21", "172.16.0.22"]'
$storage_disk_part              = '["sdb1", "sdc1", "sdd1"]'           # 所有 swift storage 节点用哪个分区来做存储, 多个例如 '["sdb1", "sdc1", "sdd5", "sde3"]'
$storage_base_dir               = '/swift-storage/'     # 所有 swift storage 节点的数据存储目录
$ring_part_power                = '18'
$ring_replicas                  = '1'                   # 数据文件的副本数量
$ring_min_part_hours            = '1'
$swift_hash_suffix              = 'http://www.longgeek.com'
$memcached_host                 = $all_on_one_ip

## Pymonitor -----------------------------------------      --------------------------------------------------------------------
# Client conf
$pym_server_ip                  = '10.0.0.20'
$pym_server_port                = '8123' 
$pym_server_log_level           = 'DEBUG'
$pym_server_buf_size            = '1024'
$pym_server_interface           = 'br100'
$pym_server_freouency           = '1'

# Server conf
$pym_api_version                = '2.0.1'
$pym_server_data_size           = '100'
$pym_server_average_delay       = '2'
$pym_client_list                = '["10.0.0.21", "10.0.0.22"]'
