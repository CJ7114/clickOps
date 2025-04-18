provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "flask_sg" {
  name = "flask_sg"
  ingress {
    from_port = 5001
    to_port = 5001
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "flask_ec2" {
    ami = "ami-053b0d53c279acc90" #ubuntu
    instance_type = "t2.micro"
    key_name = "balajikp"
    security_groups = [aws_security_group.flask_sg.name]

    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("C:/Users/CJ/Downloads/aws/balajikp.pem")
        host = self.public_ip 
    }

    provisioner "remote-exec" {
        inline = [
          "export DEBIAN_FRONTEND=noninteractive",
          "sudo apt-get update -y",
          "sudo apt-get upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'",
          "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'",
          "pip3 install flask prometheus_client",
          "nohup python3 flask_app.py > flask.log 2>&1 &"
        ]
    }
}

