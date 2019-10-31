package terraform.validation.rules.storage

import input as tfplan

default valid = false

must_have_team_label[name] { # Include name in set if
    bucket_changes := tfplan.resource_changes[_] # Some changes exist
    bucket_changes.type == "google_storage_bucket" # And they have this type
    not bucket_changes.change.after.labels.team # And does not have a team label
    name := bucket_changes.change.after.name
}

must_be_in_eu[name] { 
    bucket_changes := tfplan.resource_changes[_] 
    bucket_changes.type == "google_storage_bucket" 
    bucket_changes.change.after.location != "EU"
    name := bucket_changes.change.after.name
}

must_have_name_less_than_63_characters[name] {
    bucket_changes := tfplan.resource_changes[_] 
    bucket_changes.type == "google_storage_bucket" 
    count(bucket_changes.change.after.name) > 63
    name := bucket_changes.change.after.name
}

valid = true { # Allow is true if...
    count(must_have_team_label) == 0 # There are zero violations
    count(must_be_in_eu) == 0
    count(must_have_name_less_than_63_characters) == 0
}