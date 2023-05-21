# Background

Reading a lot of questions (mostly on Reddit) about people trying to learn Terraform, it struck me that there are few examples out there of a fully formed environment which can be used to illustrate what a terraform codebase would look like once it has been more or less built out to completion. This repository is an attempt to demonstrate how Terraform can be used to create unified, holistic infrastruction resources. The goal of this demonstration is to illustrate Terraform directory structure, module development, data structures, and language syntax using semi-real world examples.

The resources being focused on in this particular demonstration are user accounts but it can really be for anything.

# Caveats

The code in this repository should mostly work but it is generally not intended for production use. When possible, you should be using a proper identity provider for SSO.

I have attempted to document as much as possible for how and why things are structured the way they are. I am sure I am missing something or not documenting some things as clearly as I could. If you see an glaring omissions please let me know or submit a pull request to update the gaps you have noticed.

The github code assumes that you are using github.com, not github enterprise. The method for managing those resources are slightly different but the concept is essentially the same.

# Directory structure

The directory structure of a Terraform code base is extremely flexible but that flexibility can result in messy code. This repository attempts to follow best practices. In general, this is how an ideal terraform codebase will be structured:

- `modules/` will contain all of your Terraform modules. It is possible to put your modules anywhere but, for ease of future maintenance, it is preferred to centralize them. The goal of a terraform module is to have a collection of more complex resources which work together to provide a single outcome. If you need more specific sub-division of this catch-all style directory, simple sub-directories are preferred. Examples:
	- `modules/aws/{iam,rds-database,eks-cluster}/`
	- `modules/gcp/{iam,gce-instance,bigquery}/`
	- `modules/fastly/`
- `global_vars.tf` contains code which is intended to be shared between environments. In our particular case, we are building user account objects but it can be anything. The code in this file is shared by symlinking it in the directories where it will be needed.
- There should be separate environment-specific directories. What this means to your organization is going to be different for everyone but, in general, `production/`, `staging/`, and `development/` environments are good to have. This is where you will define the resources for each of the respective environments. You build them using the code defined in the `modules/` directory as a framework for the more complex resources. For resources that are too small or are overly environment-specific, you can just put them in these directories without using a module. Think of things like firewall rules.
- You can also have directories for resources intended to be shared between environments. Think of things like `dns/` or `s3_buckets/`.
- `CODEOWNERS` defines who is allowed to approved changes to which files. This is relevant when using protected branches in github.

With the exception of `modules/`, all of these directories should have their own `init.tf` file which defines unique state files. The two main reasons for this are:

1. It limits the possibility of you destroying your entire network by corrupting a global state file. When environments are broken out into their own state files, the "blast radius" of something going horribly wrong is greatly reduced.
2. It allows for better collaboration between teams. When a plan/apply is being executed, it locks changes to the state file so no other operation can happen until the running process ends. Using separate state files means three different people can be working on `iam/`, `github/`, or `production/` all at the same time without interfering with each other.