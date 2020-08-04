# frozen_string_literal: true

require_relative 'rakelib/check_changelog'

is_release = github.branch_for_head.start_with?('release/')
is_hotfix = github.branch_for_head.start_with?('hotfix/')

################################################
# Welcome message
markdown [
  "Hey 👋 I'm Eve, the friendly bot watching over SwiftGen 🤖",
  'Thanks a lot for your contribution!',
  '', '---', ''
]

need_fixes = []

################################################
# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn('PR is classed as Work in Progress') if github.pr_title.include? '[WIP]'

# Warn when there is a big PR
warn('Big PR') if git.lines_of_code > 500 && !is_release

################################################
# Check for correct base branch
to_develop = github.branch_for_base == 'develop'
to_stable = github.branch_for_base == 'stable'
if is_release
  message('This is a Release PR')
  need_fixes << warn('Release branches should be merged into the `stable` branch') unless to_stable

  require 'open3'

  stdout, _, status = Open3.capture3('bundle', 'exec', 'rake', 'changelog:check')
  markdown [
    '',
    '### ChangeLog check',
    '',
    stdout
  ]
  need_fixes << fail('Please fix the CHANGELOG errors') unless status.success?

  stdout, _, status = Open3.capture3('bundle', 'exec', 'rake', 'release:check_versions')
  markdown [
    '',
    '### Release version check',
    '',
    stdout
  ]
  need_fixes << fail('Please fix the versions inconsistencies') unless status.success?
elsif is_hotfix
  message('This is a Hotfix PR')
elsif !to_develop
  need_fixes << fail("Feature branches should start from and be merged into 'develop', " \
    "not #{github.branch_for_base}")
end

################################################
# Check `lock` files
podfile_changed = git.modified_files.include?('Podfile.lock')
package_changed = git.modified_files.include?('Package.resolved')
# rubocop:disable Style/IfUnlessModifier
if podfile_changed ^ package_changed
  need_fixes << warn('You should make sure that `Podfile.lock` and `Package.resolved` are changed in sync')
end
# rubocop:enable Style/IfUnlessModifier

# Check if DEPENDENCIES needs changes
swiftgenkit_podspec_changed = git.modified_files.include?('SwiftGenKit.podspec')
dependencies_doc_changed = git.modified_files.include?('DEPENDENCIES.md')
if podfile_changed || swiftgenkit_podspec_changed || dependencies_doc_changed
  stdout, _, status = Open3.capture3('bundle', 'exec', 'rake', 'dependencies:check[true]')
  unless status.success?
    stdout.lines.each do |message|
      need_fixes << fail(message.chomp)
    end
  end
end

################################################
# Check for a CHANGELOG entry
declared_trivial = github.pr_title.include? '#trivial'
has_changelog = git.modified_files.include?('CHANGELOG.md')
changelog_msg = ''
unless has_changelog || declared_trivial
  repo_url = github.pr_json['head']['repo']['html_url']
  pr_title = github.pr_title
  pr_title += '.' unless pr_title.end_with?('.')
  pr_number = github.pr_json['number']
  pr_url = github.pr_json['html_url']
  pr_author = github.pr_author
  pr_author_url = "https://github.com/#{pr_author}"

  need_fixes = fail("Please include a CHANGELOG entry to credit your work.  \nYou can find it at [CHANGELOG.md](#{repo_url}/blob/#{github.branch_for_head}/CHANGELOG.md).")

  changelog_msg = <<-CHANGELOG_FORMAT.gsub(/^ *\|/, '')
  |📝 We use the following format for CHANGELOG entries:
  |```
  |* #{pr_title}  
  |  [##{pr_number}](#{pr_url})
  |  [@#{pr_author}](#{pr_author_url})
  |```
  |:bulb: Don't forget to end the line describing your changes by a period and two spaces.
  CHANGELOG_FORMAT
  # changelog_msg is printed during the "Encouragement message" section, see below
end

changelog_warnings = check_changelog
unless changelog_warnings.empty?
  need_fixes << warn('Found some warnings in CHANGELOG.md')
  changelog_warnings.each do |warning|
    warn(warning[:message], file: 'CHANGELOG.md', line: warning[:line])
  end
end

################################################
# Check Documentation TOC update
doc_dir_structure_modified = (git.added_files + git.deleted_files + git.renamed_files.map(&:values)).flatten.any? { |path| path.start_with?('Documentation/') }
if doc_dir_structure_modified
  doc_files = Dir.chdir('Documentation') { Dir['{Articles/,}*{/,.md}'] } - ['README.md'] # folders + .md files immediately in either `Documentation/` or `Documentation/Articles/`
  toc_links = File.read('Documentation/README.md').scan(/\[.*\]\((.*)\)/).map(&:first).uniq # Extract markdown links from TOC
                  .reject { |s| s.start_with?('http') }.map { |s| CGI.unescape(s) } # only keep local links, and remove any percent escapes

  (doc_files - toc_links).each do |doc_not_linked|
    fail("The documentation file #{github.html_link(doc_not_linked)} is not referenced in the #{github.html_link('Documentation/README.md')}. Please add a link to it.")
  end

  (toc_links - doc_files).each do |bad_link|
    fail("The #{github.html_link('Documentation/README.md')} contains a link to \`#{bad_link}\` but that file doesn't exist. Maybe it was renamed or deleted?")
  end
end

################################################
# Encouragement message
if need_fixes.empty?
  markdown('Seems like everything is in order 👍 You did a good job here! 🤝')
else
  markdown('Once you fix those tiny nitpickings above, we should be good to go! 🙌')
  markdown(changelog_msg) unless changelog_msg.empty?
  markdown('ℹ️ _I will update this comment as you add new commits_')
end
