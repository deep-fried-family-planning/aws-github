resource "github_organization_settings" "dffp" {
  name          = "DFFP"
  billing_email = data.aws_ssm_parameter.gh_org_email.value
  location      = "United States of America"
}
