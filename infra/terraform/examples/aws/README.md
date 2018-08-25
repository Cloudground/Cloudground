#Terraform AWS Helloworld

## Requirements

* Signup for a free AWS account at [aws.amazon.com](https://aws.amazon.com)
* Create a separate user with API access (you need an AWS Access Key ID and the AWS
Secret Access Key)
  * The user needs the following permissions.. (TBD)
* Download and install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html)
  command to be able to use it, especially to use `aws configure`.
  This is not strictly required but recommended over using environment variables for secret keys.
* Configure access to AWS using `aws configure`

## Create the Helloworld sample

* Change to this directory
* Display terraform's plan: `terraform plan`
* Run the plan: `terraform apply`