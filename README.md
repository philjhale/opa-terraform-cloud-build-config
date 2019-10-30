# Open Policy Agent Terraform GCP Cloud Build config

# Configuration 
- Follow [these steps](https://github.com/philjhale/terraform-gcp-config) to set up the Google Terraform provider on GCP but don't run `terraform apply`
- 

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



# Links

- [OPA introduction](https://www.openpolicyagent.org/docs/latest/)
- [OPA Terraform tutorial](https://www.openpolicyagent.org/docs/latest/terraform/)
- [Running OPA using Docker](https://www.openpolicyagent.org/docs/latest/deployments/#running-with-docker)
- [OPA policy cheatsheet](https://www.openpolicyagent.org/docs/latest/policy-cheatsheet/)