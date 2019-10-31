# Open Policy Agent Terraform GCP Cloud Build config

# Prerequisites

- Docker
- Terraform

# Configuration 
- Follow [these steps](https://github.com/philjhale/terraform-gcp-config) to set up the Google Terraform provider on GCP but don't run `terraform apply`

# Running OPA locally

Generate the plan file.
```
terraform plan -out=tfplan.binary
```

Convert to JSON.
```
terraform show -json tfplan.binary > tfplan.json
```

Run OPA against a specified rule set.
```
docker run -v $PWD:/example openpolicyagent/opa eval --fail-defined --format pretty --data example/rules --input example/tfplan.json "data.terraform.validation.rules"
```

This should return a JSON response showing all the rule violations.
```
{
  "pubsub": {
    "must_have_name_less_than_20_characters": [
      "tf-topic-too-long-0123456789"
    ],
    "valid": false
  },
  "storage": {
    "must_be_in_eu": [
      "bucket-not-in-eu"
    ],
    "must_have_name_less_than_63_characters": [
      "bucket-name-too-long-012345678901234567890123456789012345678901234567890"
    ],
    "must_have_team_label": [
      "bucket-missing-team-label"
    ],
    "valid": false
  }
}
```

# Running using Cloud Build

Enable Cloud Build.
```
gcloud services enable cloudbuild.googleapis.com 
```

Push the images we need to Google Cloud Registry so it can be used by Cloud Build. Official documentation [here](https://cloud.google.com/container-registry/docs/pushing-and-pulling?hl=en_GB&_ga=2.159862335.-366884061.1571845612).

```
docker pull hashicorp/terraform
docker tag hashicorp/terraform gcr.io/$GOOGLE_PROJECT_ID/terraform
docker push gcr.io/$GOOGLE_PROJECT_ID/terraform

docker pull openpolicyagent/opa
docker tag openpolicyagent/opa gcr.io/$GOOGLE_PROJECT_ID/openpolicyagent
docker push gcr.io/$GOOGLE_PROJECT_ID/openpolicyagent
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
- [Rego playground](https://play.openpolicyagent.org/)
- [Rego safety FAQ](https://www.openpolicyagent.org/docs/latest/faq/#safety)
- [Example rules in forseti-security/resource-policy-evaluation-library](https://github.com/forseti-security/resource-policy-evaluation-library/tree/master/policy)