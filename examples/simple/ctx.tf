module "context" {
  source    = "bendoerr-terraform-modules/context/null"
  version   = "0.5.0"
  namespace = var.namespace
  role      = "tf-lambda"
  region    = "us-east-1"
  project   = "exmpl"
  long_dns  = true
}
