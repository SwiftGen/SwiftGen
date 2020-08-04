# frozen_string_literal: true

# Used constants:
# _none_

require 'net/http'
require 'uri'
require 'open3'

def first_match_in_file(file, regexp)
  File.foreach(file) do |line|
    m = regexp.match(line)
    return m if m
  end
end

## [ Release a new version ] ##################################################

namespace :release do
  desc 'Create a new release on GitHub, CocoaPods and Homebrew'
  task :new => [:check_versions, :confirm, 'xcode:test', :github, :cocoapods, :homebrew]

  desc 'Check if all versions from the podspecs and CHANGELOG match'
  task :check_versions do
    results = []

    Utils.table_header('Check', 'Status')

    # Check if bundler is installed first, as we'll need it for the cocoapods task (and we prefer to fail early)
    results << Utils.table_result(
      Open3.capture3('which', 'bundler')[2].success?,
      'Bundler installed',
      'Please install bundler using `gem install bundler` and run `bundle install` first.'
    )

    # Extract version from SwiftGen.podspec
    sg_version = Utils.podspec_version('SwiftGen')
    Utils.table_info('SwiftGen.podspec', sg_version)

    # Extract version from SwiftGenKit.podspec
    sgk_version = Utils.podspec_version('SwiftGenKit')
    Utils.table_info('SwiftGenKit.podspec', sgk_version)

    results << Utils.table_result(
      sg_version == sgk_version,
      'SwiftGen & SwiftGenKit versions equal',
      'Please ensure SwiftGen & SwiftGenKit use the same version numbers'
    )

    # Check if version matches the SwiftGen-Info.plist
    sg_plist = Utils.plist_version('SwiftGen')
    results << Utils.table_result(
      sg_version == sg_plist[0] && sg_plist[0] == sg_plist[1],
      'SwiftGen-Info.plist version matches',
      'Please update the version numbers in the SwiftGen-Info.plist file'
    )

    # Check if version matches the SwiftGenKit-Info.plist
    sgk_plist = Utils.plist_version('SwiftGenKit')
    results << Utils.table_result(
      sgk_version == sgk_plist[0] && sgk_plist[0] == sgk_plist[1],
      'SwiftGenKit-Info.plist version matches',
      'Please update the version numbers in the SwiftGenKit-Info.plist file'
    )

    # Check StencilSwiftKit version too
    lock_version = Utils.podfile_lock_version('StencilSwiftKit')
    pod_version = Utils.pod_trunk_last_version('StencilSwiftKit')
    results << Utils.table_result(
      lock_version == pod_version,
      "StencilSwiftKit up-to-date (latest: #{pod_version})",
      'Please update StencilSwiftKit to latest version in your Podfile'
    )

    # Check if entry present in CHANGELOG
    changelog_entry = first_match_in_file('CHANGELOG.md', /^## #{Regexp.quote(sg_version)}$/)
    results << Utils.table_result(
      !changelog_entry.nil?,
      'CHANGELOG: Release entry added',
      "Please add an entry for #{sg_version} in CHANGELOG.md"
    )

    changelog_develop = first_match_in_file('CHANGELOG.md', /^## Develop/)
    results << Utils.table_result(
      changelog_develop.nil?,
      'CHANGELOG: No develop entry',
      'Please remove entry for develop in CHANGELOG'
    )

    # Check README instructions
    readme_pod_version = first_match_in_file('README.md', /pod 'SwiftGen', '(.*)'/) || ['0.0', '0.0']
    readme_requirement = Gem::Requirement.new(readme_pod_version[1])
    readme_requirement_ok = readme_requirement.satisfied_by?(Gem::Version.new(sg_version))
    results << Utils.table_result(
      readme_requirement_ok,
      "README: pod version #{readme_pod_version[1]}",
      'Please update the README instructions with the right pod version'
    )

    exit 1 unless results.all?
  end

  task :confirm do
    version = Utils.podspec_version('SwiftGen')
    print "Release version #{version} [Y/n]? "
    exit 2 unless STDIN.gets.chomp == 'Y'
  end

  desc 'Create a zip containing all the prebuilt binaries'
  task :zip => ['cli:clean', 'cli:install'] do
    `cp LICENCE README.md CHANGELOG.md build/swiftgen`
    `cd build/swiftgen; zip -r ../swiftgen-#{Utils.podspec_version('SwiftGen')}.zip .`
  end

  def post(url, content_type)
    uri = URI.parse(url)
    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = content_type unless content_type.nil?
    yield req if block_given?
    req.basic_auth 'SwiftGen', File.read('.apitoken').chomp

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: (uri.scheme == 'https')) do |http|
      http.request(req)
    end
    unless response.code == '201'
      Utils.print_error "Error: #{response.code} - #{response.message}"
      puts response.body
      exit 3
    end
    JSON.parse(response.body)
  end

  desc 'Upload the zipped binaries to a new GitHub release'
  task :github => :zip do
    v = Utils.podspec_version('SwiftGen')

    changelog = `sed -n /'^## #{v}$'/,/'^## '/p CHANGELOG.md`.gsub(/^## .*$/, '').strip
    Utils.print_header "Releasing version #{v} on GitHub"
    puts changelog

    json = post('https://api.github.com/repos/SwiftGen/SwiftGen/releases', 'application/json') do |req|
      req.body = { tag_name: v, name: v, body: changelog, draft: false, prerelease: false }.to_json
    end

    upload_url = json['upload_url'].gsub(/\{.*\}/, "?name=swiftgen-#{v}.zip")
    zipfile = "build/swiftgen-#{v}.zip"
    zipsize = File.size(zipfile)

    Utils.print_header "Uploading ZIP (#{zipsize} bytes)"
    post(upload_url, 'application/zip') do |req|
      req.body_stream = File.open(zipfile, 'rb')
      req.add_field('Content-Length', zipsize)
      req.add_field('Content-Transfer-Encoding', 'binary')
    end
  end

  desc 'pod trunk push SwiftGen to CocoaPods'
  task :cocoapods do
    Utils.print_header 'Pushing pod to CocoaPods Trunk'
    sh 'bundle exec pod trunk push SwiftGen.podspec'
  end

  desc 'Release a new version on Homebrew and prepare a PR'
  task :homebrew do
    Utils.print_header 'Updating Homebrew Formula'
    tag = Utils.podspec_version('SwiftGen')
    sh 'git pull --tags'
    revision = `git rev-list -1 #{tag}`.chomp
    formulas_dir = Bundler.with_clean_env { `brew --repository homebrew/core`.chomp }
    Dir.chdir(formulas_dir) do
      sh 'git checkout master'
      sh 'git pull'
      sh "git checkout -b swiftgen-#{tag} origin/master"

      formula_file = "#{formulas_dir}/Formula/swiftgen.rb"
      formula = File.read(formula_file)

      new_formula = formula
                    .gsub(/(tag:\s+)".*"/, %(\\1"#{tag}"))
                    .gsub(/(revision:\s+)".*"/, %(\\1"#{revision}"))
      File.write(formula_file, new_formula)

      Utils.print_info 'Formula has been auto-updated. Do you need to also do manual updates to it before continuing [y/n]?'
      if STDIN.gets.chomp.downcase == 'y'
        sh 'open', formula_file
        puts "Once you've finished editing the formula file, press enter to continue."
        STDIN.gets.chomp
      end

      Utils.print_header 'Checking Homebrew formula...'
      Bundler.with_clean_env do
        sh 'brew audit --strict --online swiftgen'
        sh 'brew reinstall swiftgen --build-from-source'
        sh 'brew test swiftgen'
      end

      Utils.print_header 'Pushing to Homebrew'
      sh "git add #{formula_file}"
      sh "git commit -m 'swiftgen #{tag}'"
      # Add remote pointing to our fork, if it doesn't exist yet, then push the new branch to it before opening the PR
      sh 'git remote add SwiftGen https://github.com/SwiftGen/homebrew-core 2>/dev/null || true'
      sh "git push -u SwiftGen swiftgen-#{tag}"
      sh "open 'https://github.com/Homebrew/homebrew-core/compare/master...SwiftGen:swiftgen-#{tag}?expand=1'"
      sh 'git checkout master'
    end
  end
end

task :default => 'release:new'
