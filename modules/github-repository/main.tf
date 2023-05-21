resource "github_repository" "company-name" {
  name                   = var.repository_name
  visibility             = var.visibility
  has_issues             = var.has_issues
  has_discussions        = var.has_discussions
  has_wiki               = var.has_wiki
  delete_branch_on_merge = var.delete_branch_on_merge
  auto_init              = var.auto_init
  vulnerability_alerts   = var.vulnerability_alerts
}
