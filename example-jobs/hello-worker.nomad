job "hello" {
  datacenters = ["dc1"]
  type = "service"

  update {
    auto_revert = true
    canary = 1
  }

  group "worker" {
    count = 3

    task "hello" {
      driver = "docker"

      config {
        image = "jharley/hello-worker"
        port_map {
          http = 5000
        }
      }

      resources {
        network {
          port "http" {}
        }
      }

      service {
        name = "hello-worker"
        tags = ["urlprefix-/"]
        port = "http"
        check {
          name     = "alive"
          type     = "http"
          port     = "http"
          path     = "/status"
          interval = "3s"
          timeout  = "1s"
        }
      }
    }
  }
}
