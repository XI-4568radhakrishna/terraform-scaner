/*terraform {
  backend "s3" {
    bucket         = "sdlc_terraform_state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}*/
