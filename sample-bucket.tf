module "gcs_buckets" {
  source     = "terraform-google-modules/cloud-storage/google"
  project_id = "my-project"
  names      = ["my-suffix"]
  prefix     = "my-prefix-with-team"
  labels = {
    team = "my team"
  }
}

module "gcs_buckets2" {
  source     = "terraform-google-modules/cloud-storage/google"
  project_id = "my-project"
  names      = ["my-suffix"]
  prefix     = "my-prefix-no-team"
}