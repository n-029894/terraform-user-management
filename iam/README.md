# Recommendations

- Prefix your resource definitions with the object type that they are. The reason for this is because it makes it easier to parse and it's easier to delegate permissions via the CODEOWNERS file. For example:
	- `users-W.tf`
	- `group-X.tf`
	- `policy-Y.tf`
	- `role-Z.tf`
- Keep employee and contractor definitions as separate as possible. This is more of a recommendation as it relates to security policies in your organization.
- Try not to grant permissions to individual users. Use team definitions instead. It quickly turns into a management nightmare to do it otherwise.