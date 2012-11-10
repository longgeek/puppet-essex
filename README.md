openstack_puppet_rhel6.x
========================
Blog: http://www.longgeek.com

一说明:

    这个project是用puppet来部署openstack,包括swift.目前只能在rhel6.x平台上部署.
    所有的模块都是用最简单的结构来写,有很多头疼的依赖关系,基本上是一个面向过程的一个项目.
    使用说明：http://www.longgeek.com/2012/10/29/rhel-openstack-with-puppet-installed-on-a-single-node/


二目录介绍：

    1.modules:  puppet的模块路径,包含openstack各个服务的模块'mysql', 'keystone', 'auth_file', 'glance', 'rabbitmq', 'nova_control', 'nova_compute', 'nova_control_compute', 'dashboard', 'swift_proxy', 'swift_storage'
    
    2.manifests: site.pp是单节点例子，site.pp_multi_nodes多节点例子。都是用来定义节点执行的模块、全局变量、模块执行顺序

三modules下的模块：

    1.mysql: 安装配置mysql数据库,设置mysql root用户密码，并创建openstack所需的数据库，并授权用户访问.
    2.keystone: 安装配置keystone,给数据库导入keystone用户信息和endpoint
    3.auth_file: 环境变量文件
    4.glance：安装配置glance镜像服务,默认上传一个cirros镜像
    5.rabbitmq: 安装配置rabbitmq,设置rabbitmq的用户和密码
    6.nova_control:这个模块用于多节点部署，没有集成nova-compute服务
    7.nova_compute:计算节点安装nova-compute和nova-network服务(多节点部署）
    8.nova_control_compute:单节点部署，包含了nova-compute
    9.dashboard: 配置horzion这个项目
    10.swift_proxy: 配置swift代理节点
    11.swift_storage: 配置swift-storage节点

四manifests中的示例site.pp:

    site.pp是一个单节点示例，只需要更改对应的主机名、IP、swift-storage使用的分区就可以直接使用
    site.pp.multi_nodes一个多节点的例子
    
