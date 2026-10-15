terraform {
  backend "s3" {
    bucket       = "terraformstate-752651104248-eu-west-1-an"
    key          = "terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}