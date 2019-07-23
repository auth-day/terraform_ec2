variable "private_key_path" {}
variable "key_name" {
  default = "key_name"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "tf-example" { 
  ami = "ami-0730ddd9aef087500"
  instance_type = "t2.micro" 
  key_name = "${var.key_name}"

  connection {
    user = "ec2-user"
    private_key = "${file(var.private_key_path)}"
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx restart"
    ]
  }
}

output "aws_instance_public_dns" {
  value = "${aws_instance.tf-example.public_dns}"
}
