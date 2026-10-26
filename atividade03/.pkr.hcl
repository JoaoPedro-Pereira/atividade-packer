packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = "~> 1"
    }
  }
}

# 1. SOURCE: define a imagem base e o commit
source "docker" "npm" {
  image  = "ubuntu:jammy"
  commit = true
  changes = [
    "WORKDIR /app"
  ]
}

# 2. BUILD: configura a imagem
build {
  name    = "meu-nodejs-packer"
  sources = ["source.docker.npm"]

# 3. PROVISIONER: instala e configura o Apache

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y nodejs npm",
      "mkdir -p /app",
    ]
  }

  provisioner "file" {
      source = "./package.json"
      destination = "/app/package.json"
    }
  
  provisioner "shell" {
    inline = [
      "cd /app && npm install"
    ]
  }

  # 4. POST-PROCESSOR: define o repositório e as tags
  post-processor "docker-tag" {
    repository = "ambiente-node"
    tags       = ["v1"]
  }
}