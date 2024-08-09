variable "instance_count" {
  type = number
  default = 1
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}


variable "user_data_site1" {
  type = string
  default = <<-EOF
    #!/bin/bash
    
    sudo apt update

    sudo apt install nginx -y

    sudo mkdir -p /var/www/site1

    echo "<html><body><h1>Welcome to Site 1</h1></body></html>" | sudo tee /var/www/site1/index.html

    sudo tee /etc/nginx/sites-available/default <<EOL
    server {
        listen 80;
        server_name _;

        location /site1 {
            alias /var/www/site1;
            index index.html;
        }
    }
    EOL

    sudo nginx -t

    sudo systemctl restart nginx
  EOF
}

variable "user_data_site2" {
  type = string
  default = <<-EOF
    #!/bin/bash
    
    sudo apt update

    sudo apt install nginx -y

    sudo mkdir -p /var/www/site2

    echo "<html><body><h1>Welcome to Site 2</h1></body></html>" | sudo tee /var/www/site2/index.html

    sudo tee /etc/nginx/sites-available/default <<EOL
    server {
        listen 80;
        server_name _;

        location /site2 {
            alias /var/www/site2;
            index index.html;
        }
    }
    EOL

    sudo nginx -t

    sudo systemctl restart nginx
  EOF
}



variable "virtualization_types" {
  type = list(string)
  default = ["hvm"]
}

variable "owners" {
  type = list(string)
  default = ["099720109477"]
}

variable "amis" {
  type = list(string)
  default = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
}

variable "key_name" {
    type = string
}