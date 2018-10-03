# Welcome message
markdown("Hey 👋 I'm Eve, the friendly bot watching over SwiftGen 🤖\nThanks a lot for your contribution!")

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn('PR is classed as Work in Progress') if github.pr_title.include? '[WIP]'

# Warn when there is a big PR
warn('Big PR') if git.lines_of_code > 500

need_fixes = []

# Check for a CHANGELOG entry
declared_trivial = github.pr_title.include? '#trivial'
has_changelog = git.modified_files.include?('CHANGELOG.md') || declared_trivial
need_fixes << warn('Please add a CHANGELOG entry to credit your work') unless has_changelog

# Check for correct base branch
is_release = github.branch_for_head.start_with?('release/')
to_develop = github.branch_for_base == 'develop'
to_master = github.branch_for_base == 'master'
if is_release
  need_fixes << warn("Release branches should be merged into 'master'") unless to_master

  require 'open3'
  
  stdout, _, status = Open3.capture3('bundle', 'exec', 'rake', 'changelog:check')
  markdown [
  	'',
  	"### ChangeLog check",
  	'',
  	stdout
  ]
  need_fixes << warn('Please fix the CHANGELOG errors') unless status.success?
  
  stdout, _, status = Open3.capture3('bundle', 'exec', 'rake', 'release:check_versions')
  markdown [
  	'',
  	'### Release version check',
  	'',
  	stdout
  ]
  need_fixes << warn('Please fix the versions inconsistencies') unless status.success?
elsif !to_develop
  need_fixes << warn("Feature branches should start from and be merged into 'develop', " \
    "not #{github.branch_for_base}")
end

# Check `lock` files
podfile_changed = git.modified_files.include?('Podfile.lock')
package_changed = git.modified_files.include?('Package.resolved')
if podfile_changed ^ package_changed
  need_fixes << warn("You should make sure that `Podfile.lock` and `Package.resolved` are changed in sync")
end

# Encouragement message
markdown ['', '---', '']
if need_fixes.empty?
	markdown('Seems like everything is in order 👍 You did a good job here! 🤝')
else
	markdown('Once you fix those tiny nitpickings above, we should be good to go! 🙌')
	markdown('_Note: I will update this comment as you add new commits_')
end
