#
# GH Team - Admin
#
resource "github_team" "admin" {
  name    = "Admin"
  privacy = "closed"
}

resource "github_organization_security_manager" "admin" {
  team_slug = github_team.admin.slug
}

resource "github_team_settings" "admin" {
  team_id = github_team.admin.id
  review_request_delegation {
    algorithm    = "ROUND_ROBIN"
    member_count = 1
    notify       = true
  }
}

resource "github_team_repository" "admin" {
  for_each   = element(github_repository.public[*], 0)
  team_id    = github_team.admin.id
  repository = each.value.name
  permission = "admin"
}

resource "github_team_members" "admin" {
  team_id = github_team.docs.id
  dynamic "members" {
    for_each = { for k, v in var.users : k => v if element(v, 1) == github_team.admin.name }
    content {
      username = members.key
      role     = members.value[2]
    }
  }
}


#
# GH Team - Dev
#
resource "github_team" "dev" {
  name    = "Dev"
  privacy = "closed"
}

resource "github_team_settings" "dev" {
  team_id = github_team.dev.id
  review_request_delegation {
    algorithm    = "ROUND_ROBIN"
    member_count = 1
    notify       = true
  }
}

resource "github_team_repository" "dev" {
  for_each   = element(github_repository.public[*], 0)
  team_id    = github_team.dev.id
  repository = each.value.name
  permission = "push"
}

resource "github_team_members" "dev" {
  team_id = github_team.docs.id
  dynamic "members" {
    for_each = { for k, v in var.users : k => v if element(v, 1) == github_team.dev.name }
    content {
      username = members.key
      role     = members.value[2]
    }
  }
}


#
# GH Team - Docs
#
resource "github_team" "docs" {
  name    = "Docs"
  privacy = "closed"
}

resource "github_team_settings" "docs" {
  team_id = github_team.docs.id
  review_request_delegation {
    algorithm    = "ROUND_ROBIN"
    member_count = 1
    notify       = true
  }
}

resource "github_team_repository" "docs" {
  team_id    = github_team.docs.id
  repository = github_repository.public["clash_discord_bot_assets"].name
  permission = "admin"
}

resource "github_team_members" "docs" {
  count   = 0
  team_id = github_team.docs.id
  dynamic "members" {
    for_each = { for k, v in var.users : k => v if element(v, 1) == github_team.docs.name }
    content {
      username = members.key
      role     = members.value[2]
    }
  }
}
