terraform {
  backend "s3" {
    bucket  = "petclinicdeploy"
    key     = "terraform"
    region  = "us-east-1"
    profile = "aashish"
  }
}
