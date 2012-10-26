class nova_control_compute {
    include nova_control_compute::install, nova_control_compute::config, nova_control_compute::service, nova_control_compute::command
}
