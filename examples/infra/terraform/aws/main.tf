provider "aws" {
  # Note: At AWS, you have to use different AMIs for different regions, it seems.
  # So if you want to change the region, you also have to change the AMIs. 
  region = "us-east-1"
}

resource "aws_instance" "helloworld" {
  ami   = "ami-40d28157"
  count = 1

  instance_type = "t2.micro"

  tags {
    Name = "terraform-helloworld"
  }
}
