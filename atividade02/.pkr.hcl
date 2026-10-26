
packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.8"
    }
  }
}

source "docker" "python3" {
  image  = "ubuntu:jammy"
  commit = true

  changes = [
    "WORKDIR /app",
    "EXPOSE 5000"
  ]
}

build {
  name    = "meu-python3-packer"
  sources = ["source.docker.python3"]

  # Atualizar os pacotes e instalar o Apache
  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y python3 python3-pip",
      "mkdir -p /app",
      "pip3 install Flask"
    ]
  }

  # Atribuir o nome solicitado à imagem final
  post-processor "docker-tag" {
    repository = "ambient-dev-python"
    tags       = ["v1"]
  }
}
