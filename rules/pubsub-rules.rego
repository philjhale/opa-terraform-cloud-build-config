package terraform.validation.rules.pubsub

import input as tfplan

default valid = false

must_have_name_less_than_20_characters[name] {
    pubsub_changes := tfplan.resource_changes[_] 
    pubsub_changes.type == "google_pubsub_topic" 
    count(pubsub_changes.change.after.name) > 20
    name := pubsub_changes.change.after.name
}

valid = true {                                     
    count(must_have_name_less_than_20_characters) == 0
}