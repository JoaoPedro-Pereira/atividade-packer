packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = "~> 1"
    }
  }
}

# 1. SOURCE: define a imagem base e o commit
source "docker" "apache2" {
  image  = "ubuntu:jammy"
  commit = true

  changes = [
    "EXPOSE 80",
    "CMD [\"apache2ctl\",\"-D\", \"FOREGROUND\"]"
  ]
}

# 2. BUILD: configura a imagem
build {
  name    = "meu-apache-packer"
  sources = ["source.docker.apache2"]

# 3. PROVISIONER: instala e configura o Apache

  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update",
      "apt-get install -y --no-install-recommends nginx ca-certificates",
      "apt-get install -y --no-install-recommends apache2",
      "mkdir -p /var/www/html",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*"
    ]
  }

  provisioner "file" {
      source = "./index.html"
      destination = "/var/www/html/index.html"
    }

  # 4. POST-PROCESSOR: define o repositório e as tags
  post-processor "docker-tag" {
    repository = "meu-apache-packer"
    tags       = ["latest"]
  }
}