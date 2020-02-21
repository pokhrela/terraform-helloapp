terraform {
  backend "s3" {
    bucket  = "petclinicdeploy"
    key     = "terraform/a.tfstate"
    region  = "us-east-1"
    shared_credentials_file = "/home/aashish/.aws/credentials"
    profile = "aashish"
  }
}
