terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "iciformation_net" {
  name = "iciformation_net"
}

resource "docker_image" "web" {
  name = "iciformation_web:latest"
  build {
    context    = "${path.module}/../Partie2"
    dockerfile = "${path.module}/../Partie2/Dockerfile"
  }
}

resource "docker_image" "proxy" {
  name = "nginx:alpine"
  keep_locally = false
}

resource "docker_image" "db" {
  name = "postgres:16"
  keep_locally = false
}

resource "docker_container" "db" {
  name  = "iciformation_db"
  image = docker_image.db.name
  env = [
    "POSTGRES_USER=iciformation",
    "POSTGRES_PASSWORD=iciformation",
    "POSTGRES_DB=iciformationdb"
  ]

  volumes {
    host_path      = "${abspath("${path.module}/pgdata")}"
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.iciformation_net.name
  }

  ports {
    internal = 5432
    external = 5432
  }
}

resource "docker_container" "web" {
  name  = "iciformation_web"
  image = docker_image.web.name
  networks_advanced {
    name = docker_network.iciformation_net.name
  }
  depends_on = [docker_container.db]
}


resource "docker_container" "proxy" {
  name  = "iciformation_proxy"
  image = docker_image.proxy.name
  volumes {
    host_path      = "${abspath("${path.module}/../Partie2/nginx.conf")}"
    container_path = "/etc/nginx/nginx.conf"
    read_only      = true
  }
  ports {
    internal = 80
    external = 80
  }
  networks_advanced {
    name = docker_network.iciformation_net.name
  }
  depends_on = [docker_container.web]
}
