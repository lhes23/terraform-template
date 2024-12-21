# Need to explicitly add the variables because it runs before everything else
terraform {
  backend "s3" {
    bucket         = "terraform-template-state-bucket" # name must be the same from the state-backend bucket name
    key            = "staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terra-dynamodb-table" # name must be the same from the state-backend dynamodb table name
    encrypt        = true
  }
}