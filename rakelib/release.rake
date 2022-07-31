# frozen_string_literal: true

# Used constants:
# - BUILD_DIR

require 'digest'
require 'net/http'
require 'open3'
require 'open-uri'
require 'uri'

def first_match_in_file(file, regexp)
  File.foreach(file) do |line|
    m = regexp.match(line)
    return m if m
  end
end

## [ Release a new version ] ##################################################

namespace :release do
  desc 'Create a new release on GitHub, CocoaPods and Homebrew'
  task :new => [:check_versions, :confirm, 'spm:test', :github, :cocoapods, :homebrew]

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
    sg_version = Utils.podspec_version(POD_NAME)
    Utils.table_info('SwiftGen.podspec', sg_version)

    # Extract version from SwiftGenKit.podspec
    sgk_version = Utils.podspec_version('SwiftGenKit')
    Utils.table_info('SwiftGenKit.podspec', sgk_version)

    results << Utils.table_result(
      sg_version == sgk_version,
      'SwiftGen & SwiftGenKit versions equal',
      'Please ensure SwiftGen & SwiftGenKit use the same version numbers'
    )

    # Check if version matches the Versions.swift
    sg_code = File.open('Sources/SwiftGen/Version.swift').grep(/swiftgen = "(.+)"/) { Regexp.last_match(1) }.first
    results << Utils.table_result(
      sg_version == sg_code,
      'SwiftGen Version.swift version matches',
      'Please update the version numbers in Versions.swift file'
    )

    # Check if version matches the Versions.swift
    sgk_code = File.open('Sources/SwiftGen/Version.swift').grep(/swiftGenKit = "(.+)"/) { Regexp.last_match(1) }.first
    results << Utils.table_result(
      sgk_version == sgk_code,
      'SwiftGenKit Version.swift version matches',
      'Please update the version numbers in Versions.swift file'
    )

    # Check StencilSwiftKit version too
    lock_version = Utils.spm_resolved_version('StencilSwiftKit')
    pod_version = Utils.pod_trunk_last_version('StencilSwiftKit')
    results << Utils.table_result(
      lock_version == pod_version,
      "StencilSwiftKit up-to-date (latest: #{pod_version})",
      'Please update StencilSwiftKit to latest version in your Package.swift'
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
    version = Utils.podspec_version(POD_NAME)
    print "Release version #{version} [Y/n]? "
    exit 2 unless STDIN.gets.chomp == 'Y'
  end

  desc 'Create a zip containing all the prebuilt binaries'
  task :zip => ['cli:clean'] do
    # Force a universal build
    task('cli:install').invoke(nil, true)
    `cp LICENCE README.md CHANGELOG.md #{BUILD_DIR}/swiftgen`
    `cd #{BUILD_DIR}/swiftgen; zip -r ../swiftgen-#{Utils.podspec_version(POD_NAME)}.zip .`
  end

  desc 'Create a zip containing all the prebuilt binaries in the artifact bundle format (for SwiftPM Package Plugins)'
  task :artifactbundle => :zip do
    bundle_dir = "#{BUILD_DIR}/swiftgen.artifactbundle"
    version = Utils.podspec_version(POD_NAME)

    # Copy the built product to an artifact bundle
    `mkdir -p #{bundle_dir}`
    `cp -Rf #{BUILD_DIR}/swiftgen #{bundle_dir}`

    # Write the `info.json` artifact bundle manifest
    info_template = File.read("rakelib/artifactbundle.info.json.template")
    info_file_content = info_template.gsub(/(VERSION)/, version)
    
    File.open("#{bundle_dir}/info.json", "w") do |f|
      f.write(info_file_content)   
    end

    # Zip the bundle
    `cd #{BUILD_DIR}; zip -r swiftgen-#{version}.artifactbundle.zip swiftgen.artifactbundle/`
  end

  desc "Create a new GitHub release"
  task :github => :artifactbundle do
    require 'octokit'

    client = Utils.octokit_client
    version = Utils.podspec_version(POD_NAME)
    body = Utils.top_changelog_entry
    artifacts = [
      "swiftgen-#{version}.zip",
      "swiftgen-#{version}.artifactbundle.zip"
    ]
    repo_name = File.basename(`git remote get-url origin`.chomp, '.git').freeze
    
    # Create (or update) release
    puts "Pushing release notes for tag #{version}"
    begin
      release = client.release_for_tag("SwiftGen/#{repo_name}", version)
      client.update_release(release.url, tag_name: version, name: version, body: body)
    rescue Octokit::NotFound
      release = client.create_release("SwiftGen/#{repo_name}", version, name: version, body: body)
    end

    # Upload our artifacts
    artifacts.each do |artifact|
      artifact_path = File.join(BUILD_DIR, artifact)
      client.upload_asset(release.url, artifact_path, name: artifact, content_type: 'application/zip')
    end
  end

  desc 'pod trunk push SwiftGen to CocoaPods'
  task :cocoapods do
    Utils.print_header 'Pushing pod to CocoaPods Trunk'
    sh "bundle exec pod trunk push #{POD_NAME}.podspec"
  end

  desc 'Release a new version on Homebrew and prepare a PR'
  task :homebrew do
    Utils.print_header 'Updating Homebrew Formula'
    
    tag = Utils.podspec_version(POD_NAME)
    archive_url = "https://github.com/SwiftGen/SwiftGen/archive/#{tag}.tar.gz"
    digest = Digest::SHA256.hexdigest URI.open(archive_url).read

    formulas_dir = Bundler.with_original_env { `brew --repository homebrew/core`.chomp }
    Dir.chdir(formulas_dir) do
      sh 'git checkout master'
      sh 'git pull'
      sh "git checkout -b swiftgen-#{tag} origin/master"

      formula_file = "#{formulas_dir}/Formula/swiftgen.rb"
      formula = File.read(formula_file)

      new_formula = formula
                    .gsub(/(url\s+)".*"/, %(\\1"#{archive_url}"))
                    .gsub(/(sha256\s+)".*"/, %(\\1"#{digest}"))
      File.write(formula_file, new_formula)

      Utils.print_info 'Formula has been auto-updated. Do you need to also do manual updates to it before continuing [y/n]?'
      if STDIN.gets.chomp.downcase == 'y'
        sh 'open', formula_file
        puts "Once you've finished editing the formula file, press enter to continue."
        STDIN.gets.chomp
      end

      Utils.print_header 'Checking Homebrew formula...'
      Bundler.with_original_env do
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
