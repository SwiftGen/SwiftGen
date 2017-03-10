# Used constants:
# none

namespace :changelog do
  desc 'Add the empty CHANGELOG entries after a new release'
  task :reset do |task|
    changelog = File.read('CHANGELOG.md')
    abort('A Master entry already exists') if changelog =~ /^##\s*Master$/
    changelog.sub!(/^##[^#]/, "#{header}\\0")
    File.write('CHANGELOG.md', changelog)
  end

  def header
    return <<-HEADER.gsub(/^\s*\|/,'')
      |## Master
      |
      |### Bug Fixes
      |
      |_None_
      |
      |### Breaking Changes
      |
      |_None_
      |
      |### New Features
      |
      |_None_
      |
      |### Internal Changes
      |
      |_None_
      |
    HEADER
  end
end
