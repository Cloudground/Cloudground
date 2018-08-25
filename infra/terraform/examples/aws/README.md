#Terraform AWS Helloworld

## Prerequisites

* Signup for a free AWS account at [aws.amazon.com](https://aws.amazon.com)
* Create a separate user with API access (you need an AWS Access Key ID and the AWS
Secret Access Key)
  * The user needs the following permissions... (TBD)
* Download and install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html)
  command.
* Configure access to AWS using `aws configure`. This is not strictly required but _recommended_ over using environment variables for secret keys.
* If you want tab-complete on the shell, see
  [AWS CLI command completion](https://docs.aws.amazon.com/cli/latest/userguide/cli-command-completion.html).
* Download and install HashiCorp [Terraform](https://www.terraform.io/downloads.html).

## Create the Helloworld sample

* Change to this directory
* Check AWS CLI configuration: `aws configure list`
* For the first run, init terraform: `terraform init`
* Display terraform's plan: `terraform plan`
* Run the plan: `terraform apply`
