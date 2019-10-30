# Open Policy Agent Terraform GCP Cloud Build config

# Prerequisites

- Docker
- Terraform

# Configuration 
- Follow [these steps](https://github.com/philjhale/terraform-gcp-config) to set up the Google Terraform provider on GCP but don't run `terraform apply`

# Running OPA locally

Generate the plan file.
```
terraform plan --out tfplan.binary
```

Convert to JSON.
```
terraform show -json tfplan.binary > tfplan.json
```

Run OPA against a specified rule.
```
docker run -v $PWD:/example openpolicyagent/opa eval --data example/sample-bucket.rego --input example/tfplan.json "data.terraform.validation.[rule-name]"
# E.g.
docker run -v $PWD:/example openpolicyagent/opa eval --data example/sample-bucket.rego --input example/tfplan.json "data.terraform.validation.any_buckets_name_missing_team_label"
```

This should return a JSON response.
```
{
  "result": [
    {
      "expressions": [
        {
          "value": [
            "my-prefix-no-team-eu-my-suffix"
          ],
          "text": "data.terraform.validation.any_buckets_name_missing_team_label",
          "location": {
            "row": 1,
            "col": 1
          }
        }
      ]
    }
  ]
}
```

# Running using Cloud Build

Enable Cloud Build.
```
gcloud services enable cloudbuild.googleapis.com 
```

Push a Terraform Docker image to Google Cloud Registry so it can be used by Cloud Build. Office documentation [here](https://cloud.google.com/container-registry/docs/pushing-and-pulling?hl=en_GB&_ga=2.159862335.-366884061.1571845612).

```
docker pull hashicorp/terraform
docker tag hashicorp/terraform gcr.io/$GOOGLE_PROJECT_ID/terraform
docker push gcr.io/$GOOGLE_PROJECT_ID/terraform
```

Submit a build. The results will be shown in the console and can also be viewed in the [Cloud Console](https://console.cloud.google.com/cloud-build).
```
gcloud builds submit .
```

# Links

- [OPA introduction](https://www.openpolicyagent.org/docs/latest/)
- [OPA Terraform tutorial](https://www.openpolicyagent.org/docs/latest/terraform/)
- [Running OPA using Docker](https://www.openpolicyagent.org/docs/latest/deployments/#running-with-docker)
- [OPA policy cheatsheet](https://www.openpolicyagent.org/docs/latest/policy-cheatsheet/)