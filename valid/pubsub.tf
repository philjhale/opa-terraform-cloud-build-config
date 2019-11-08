module "pubsub1" {
  source     = "terraform-google-modules/pubsub/google"
  topic      = "tf-topic"
  project_id = "my-project"
}

module "pubsub2" {
  source     = "terraform-google-modules/pubsub/google"
  topic      = "valid topic"
  project_id = "my-project"
}