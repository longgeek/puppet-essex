class nova_control {
    include nova_control::install, nova_control::config, nova_control::service, nova_control::command
}
