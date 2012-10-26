class nova_compute {
    include nova_compute::install, nova_compute::config, nova_compute::service, nova_compute::command
}
