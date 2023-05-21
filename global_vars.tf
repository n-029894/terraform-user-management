// Place global variables in all environments in here. Symlink this file into
// all directories where it will be used.
locals {
  // The fileset() function is used to find all team file definitions in the
  // appropriate directory. We specify a path of '../teams' even though we are
  // in the top level directory of this repository. The reason for this is
  // because this file is intended to be symlinked into each of the child
  // directories where the team definitions are required. The path relative to
  // the child directories is '../teams'
  team = { for f in fileset(path.module, "../teams/**.yaml") :
    // We use the filename as the team name
    trimsuffix(basename(f), ".yaml") => {
      for k, v in yamldecode(file(f)) :
      // Dynamically insert team_name and email so we can more easily reference
      // them later
      k => merge(v, { "email" = k }, { "team_name" = trimsuffix(basename(f), ".yaml") })
    }
  }
}
