# Used constants:
# none

require 'octokit'

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

  desc 'Check if links to issues and PRs use matching numbers between text & link'
  task :check do |task|
    current_repo = File.basename(`git rev-parse --show-toplevel`.chomp).freeze
    slug_re = '([a-zA-Z]*/[a-zA-Z]*)'
    links = %r{\[#{slug_re}?\#([0-9]+)\]\(https://github.com/#{slug_re}/(issues|pull)/([0-9]+)\)}
    all_wrong_links = []
    File.readlines('CHANGELOG.md').each_with_index do |line, idx|
      wrong_links = line.scan(links)
        .reject do |m|
          (slug, num, url_slug, url_num) = [m[0] || "SwiftGen/#{current_repo}", m[1], m[2], m[4]]
          (slug == url_slug) && (num == url_num)
        end.map do |m|
          " - Line #{idx+1}, link text is #{m[0]}##{m[1]} but links points to #{m[2]}##{m[4]}"
        end
      all_wrong_links.concat(wrong_links)
    end
    if all_wrong_links.empty?
      puts "\u{2705}  All links correct"
    else
      puts "\u{274C}  Some wrong links found:\n" + all_wrong_links.join("\n")
    end
  end

  desc "Push the CHANGELOG's top section as a GitHub release"
  task :push_github_release do
    client = Utils.octokit_client
    tag = Utils.top_changelog_version
    body = Utils.top_changelog_entry

    repo_url = `git remote -v | grep push`.split(' ')[1]
    repo_name = File.basename(repo_url, '.git')
    client.create_release("SwiftGen/#{repo_name}", tag, :body => body)
  end
end
