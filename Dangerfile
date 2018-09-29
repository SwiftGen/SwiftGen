# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

# Check for a CHANGELOG entry
warn("Please add a CHANGELOG entry") unless git.modified_files.include?("CHANGELOG.md")

is_release = github.branch_for_head.start_with?('release/')
to_develop = github.branch_for_base == 'develop'
to_master = github.branch_for_base == 'master'
if is_release
  warn("Release branches should be merged to 'master'") unless to_master
else
  warn("Feature branches should start from and be merged to 'develop'") unless to_develop
end
