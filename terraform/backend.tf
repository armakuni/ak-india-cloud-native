terraform {
  backend "s3" {
    bucket  = "terraform-course-global-state"
    key     = "devops/cloud-native"
    region  = "eu-west-2"
    profile = "cloud-native-ci"
  }
}