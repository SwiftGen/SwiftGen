# frozen_string_literal: true

# Used constants:
# _none_

require 'yaml'

namespace :dependencies do
  TOOLS = %w(SwiftLint)

  desc 'Check if the DEPENDENCIES.md file and Package.swift + SwiftGenKit.podspec are in sync'
  # options: Use 'check[plain]' to avoid coloring and dashes. Useful for using in Dangerfile.
  task :check, [:plain] do |_, args|
    spm_deps = File.open('Package.swift').grep(/\.package\(url: ".+\/(.+?)\.git", .+\)/) { Regexp.last_match(1) }
    swiftgenkit_deps = Utils.podspec_as_json('SwiftGenKit')['dependencies'].keys
    all_core_deps = (TOOLS + spm_deps + swiftgenkit_deps).uniq
    documented_deps = File.open('DEPENDENCIES.md').grep(/### (.*)/) { Regexp.last_match(1) }

    missing_deps = (all_core_deps - documented_deps).sort
    extra_deps = (documented_deps - all_core_deps).sort

    next if missing_deps.empty? && extra_deps.empty?

    messages = missing_deps.map do |d|
      "Dependency \`#{d}\` should be documented in \`DEPENDENCIES.md\` with an explanation " \
        "as to why it is needed, and a link to the dependency's license"
    end + extra_deps.map do |d|
      "Dependency \`#{d}\` is documented in \`DEPENDENCIES.md\` but we don't seem to depend " \
        'on it anymore'
    end

    if args[:plain] == 'true'
      puts messages.join("\n")
    else
      messages.each { |m| Utils.print_error(" - #{m}") }
    end
    exit 1
  end
end
