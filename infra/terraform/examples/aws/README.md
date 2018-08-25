#Terraform AWS Helloworld

## Prerequisites

* Signup for a free AWS account at [aws.amazon.com](https://aws.amazon.com)
* Create a separate user with API access (you need the AWS Access Key ID and the AWS
Secret Access Key) in the [IAM section](https://console.aws.amazon.com/iam/) of the 
[AWS Console](https://console.aws.amazon.com/).
  * The user needs the following permissions for this example:
    * AmazonEC2FullAccess
    * AmazonS3FullAccess (not yet required)
  * Store the credentials in a secure password manager for later use. There is no
    way to retrieve the credentials from AWS at a later time.
* Download and install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html)
  command.
* Configure access to AWS using `aws configure`. This is not strictly required but _recommended_ over using environment variables for secret keys.
* To make tab completion work on your shell, see
  [AWS CLI command completion](https://docs.aws.amazon.com/cli/latest/userguide/cli-command-completion.html)
  for how to enable it in your shell. If you installed the AWS CLI using the default method of using _pip_, adding
  the following line to your `.bashrc` file should work:  
    `complete -C "$(which aws_completer)" aws`
* Download and install HashiCorp [Terraform](https://www.terraform.io/downloads.html).

## Create the Helloworld sample

* Change to this directory
* Check AWS CLI configuration: `aws configure list`
* For the first run, init terraform: `terraform init`
* Display terraform's plan: `terraform plan`
* Run the plan: `terraform apply`

## Cleanup

When you are done, you can delete created resources using: `terraform destroy`.
Note that there is no undo!
