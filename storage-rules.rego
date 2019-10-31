package terraform.validation

import input as tfplan

# Rules tutorial https://www.openpolicyagent.org/docs/latest/#rules
# Complete rule. Does the Terraform plan include buckets?
# any_buckets = true { # True if
#     changes := tfplan.resource_changes[_] # Some changes exist
#     changes.type == "google_storage_bucket" # And they have this type
# }

# Incremental rule. Find the name of buckets in the Terraform plan.
all_buckets[bucket_changes] { # Include bucket in set if
    bucket_changes := tfplan.resource_changes[_] # Some changes exist
    bucket_changes.type == "google_storage_bucket" # And they have this type
}

# Incremental rule. Find buckets without a team label in the Terraform plan
must_have_team_label[bucket_changes.change.after.name] { # Include name in set if
    some bucket_changes
    all_buckets[bucket_changes]
    not bucket_changes.change.after.labels.team # And does not have a team label
}

# must_have_team_label[changes.change.after.name] { # Include name in set if
#     changes := tfplan.resource_changes[_] # Some changes exist
#     changes.type == "google_storage_bucket" # And they have this type
#     not changes.change.after.labels.team # And does not have a team label
# }

must_be_in_eu[bucket_changes.change.after.name] { # Include name in set if
    some bucket_changes
    all_buckets[bucket_changes]
    bucket_changes.change.after.location != "EU"
}

must_have_name_less_than_63_characters[bucket_changes.change.after.name]
{
    some bucket_changes
    all_buckets[bucket_changes]
    count(bucket_changes.change.after.name) > 63
}

violations[buckets] {
    some bucket_name1
    must_have_team_label[bucket_name1]
    
    some bucket_name2
    must_be_in_eu[bucket_name2]
    
    buckets := bucket_name1 | bucket_name2
}

allow = true {                                      # allow is true if...
    count(must_have_team_label) == 0                           # there are zero violations.
    count(must_be_in_eu) == 0
}


# policies [policy_name] {
#     policy := data.gcp.cloudfunctions.projects.locations.functions.policy[policy_name]
# }

# violations [policy_name] {
#     policy := data.gcp.cloudfunctions.projects.locations.functions.policy[policy_name]
#     policy.valid != true
# }