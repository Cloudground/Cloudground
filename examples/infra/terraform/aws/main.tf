provider "aws" {
  # Note: At AWS, you have to use different AMIs for different regions, it seems.
  # So if you want to change the region, you also have to change the AMIs. 
  region = "us-east-1"
}

resource "aws_instance" "helloworld" {
  ami   = "ami-40d28157"
  count = 1

  instance_type          = "t2.micro"
  vpc_security_group_ids = [" ${aws_security_group.instance.id}"]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello World!" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF

  tags {
    Name = "terraform-helloworld"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-helloworld-instance"

  ingress {
    from_port = 80

    to_port = 8080

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
}
