package terraform.validation

import input as tfplan

# Rules tutorial https://www.openpolicyagent.org/docs/latest/#rules
# Complete rule. Does the Terraform plan include buckets?
any_buckets = true { # True if
    changes := tfplan.resource_changes[_] # Some changes exist
    changes.type == "google_storage_bucket" # And they have this type
}

# Incremental rule. Find the name of buckets in the Terraform plan.
any_buckets_name[changes.change.after.name] { # Include name in set if
    changes := tfplan.resource_changes[_] # Some changes exist
    changes.type == "google_storage_bucket" # And they have this type
}

# Incremental rule. Find buckets without a team label in the Terraform plan
any_buckets_missing_team_label[changes.change.after.name] { # Include name in set if
    changes := tfplan.resource_changes[_] # Some changes exist
    changes.type == "google_storage_bucket" # And they have this type
    not changes.change.after.labels.team # And does not have a team label
}
