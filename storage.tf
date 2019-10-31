module "gcs_buckets" {
  source     = "terraform-google-modules/cloud-storage/google"
  project_id = "my-project"
  names      = ["bucket-not-in-eu"]
  prefix     = ""
  location   = "US" # Only EU is allowed
  labels = {
    team = "my team"
  }
}

module "gcs_buckets2" {
  source     = "terraform-google-modules/cloud-storage/google"
  project_id = "my-project"
  names      = ["bucket-missing-team-label"]
  prefix     = ""
  # Missing team label
}

module "gcs_buckets3" {
  source     = "terraform-google-modules/cloud-storage/google"
  project_id = "my-project"
  names      = ["bucket-name-too-long-012345678901234567890123456789012345678901234567890"] # Bucket name too long
  prefix     = ""
  labels = {
    team = "my team"
  }
}

