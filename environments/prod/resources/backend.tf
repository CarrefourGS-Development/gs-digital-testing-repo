terraform {
  backend "gcs" {
    bucket = "c4-gs-digital-root-dev-tfstate-prod"
    prefix = "projects/gs-digital-brz-qms-prod/resources"
  }
}