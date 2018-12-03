job "echo-example" {
  datacenters = ["dc1"]

  group "echo" {
    count = "3"
    task "server" {
      driver = "exec"

      artifact {
        source = "https://github.com/hashicorp/http-echo/releases/download/v0.2.3/http-echo_0.2.3_linux_amd64.tar.gz"

        options {
          checksum = "sha256:e30b29b72ad5ec1f6dfc8dee0c2fcd162f47127f2251b99e47b9ae8af1d7b917"
        }
      }

      config {
        command = "local/http-echo"
        args = [
          "-listen", ":5678",
          "-text", "echo echo echo",
        ]
      }

      resources {
        network {
          mbits = 10
          port "http" {
            static = "5678"
          }
        }
      }


      service {
        name = "http-echo"
        tags = [ "http-echo", "urlprefix-/echo" ]
        port = "http"
        check {
          type     = "http"
          port     = "http"
          interval = "10s"
          timeout  = "2s"
          path = "/"
        }
      }

    }
  }
}
