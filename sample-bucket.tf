module "gcs_buckets" {
  source     = "terraform-google-modules/cloud-storage/google"
  project_id = "my-project"
  names      = ["bucket-suffix"]
  prefix     = "bucket-prefix-with-team-label"
  labels = {
    team = "my team"
  }
}

module "gcs_buckets2" {
  source     = "terraform-google-modules/cloud-storage/google"
  project_id = "my-project"
  names      = ["bucket-suffix"]
  prefix     = "bucket-prefix-no-team-label"
}