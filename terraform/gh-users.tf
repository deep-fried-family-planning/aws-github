variable "users" {
  type = map(list(string))
  default = {
    ryanemcdaniel     = ["admin", "Admin", "maintainer"]
    "Khatry-With-A-Y" = ["member", "Dev", "member"]
    "5hubham6"        = ["member", "Dev", "member"]
  }
}

data "github_user" "users" {
  for_each = var.users
  username = each.key
}

locals {
  main_force_push_bypassers = [
    data.github_user.users["ryanemcdaniel"].node_id
  ]
  main_dismissal_restrictions = [
    "/${data.github_user.users["ryanemcdaniel"].username}"
  ]
  main_pull_request_bypassers = [
    "/${data.github_user.users["ryanemcdaniel"].username}"
  ]
}

resource "github_membership" "users" {
  for_each             = var.users
  username             = each.key
  role                 = element(each.value, 0)
  downgrade_on_destroy = true
}
