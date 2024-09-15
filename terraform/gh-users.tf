variable "users" {
  type = map(list(string))
  default = {
    ryanemcdaniel     = ["admin"]
    "Khatry-With-A-Y" = ["member"]
    "5hubham6"        = ["member"]
  }
}

data "github_user" "users" {
  for_each = var.users
  username = each.key
}

resource "github_membership" "users" {
  for_each             = var.users
  username             = each.key
  role                 = element(each.value, 0)
  downgrade_on_destroy = true
}