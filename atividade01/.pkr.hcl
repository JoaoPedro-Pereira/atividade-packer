
packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.8"
    }
  }
}

source "docker" "apache" {
  image  = "ubuntu:jammy"
  commit = true
}

build {
  name    = "meu-apache-packer"
  sources = ["source.docker.apache"]

  # Atualizar os pacotes e instalar o Apache
  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install apt-utils
      "DEBIAN_FRONTEND=noninteractive apt-get install -y apache2",
      "mkdir -p /var/www/html"
    ]
  }

  # Copiar o HTML local para um diretório temporário
  provisioner "file" {
    source      = "./index.html"
    destination = "/tmp/index.html"
  }

  # Mover o HTML para o diretório do Apache
  provisioner "shell" {
    inline = [
      "cp /tmp/index.html /var/www/html/index.html",
      "chmod 644 /var/www/html/index.html",
    ]
  }

  # Atribuir o nome solicitado à imagem final
  post-processor "docker-tag" {
    repository = "atividade01"
    tags       = ["latest"]
  }
}
