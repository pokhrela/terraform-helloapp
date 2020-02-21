terraform {
  backend "s3" {
    bucket  = "petclinicdeploy"
    key     = "terraform"
    region  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile = "aashish"
  }
}
