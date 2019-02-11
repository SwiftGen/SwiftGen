# Used constants:
# none

require 'yaml'
require 'json'
require 'open3'

namespace :dependencies do
  desc 'Check if the DEPENDENCIES.md file and Podfile.lock + SwiftGenKit.podspec are in sync'
  task :check do
    podfile_deps = YAML::load_file('Podfile.lock')['PODS'].map do |entry|
      key = entry.is_a?(Hash) ? entry.keys.first : entry
      key.gsub(/ \([0-9.]*\)$/,'')
    end

    swiftgenkit_deps = Utils.podspec_as_json('SwiftGenKit')['dependencies'].keys

    all_core_deps = (podfile_deps + swiftgenkit_deps).uniq
    documented_deps = File.open('DEPENDENCIES.md').grep(/### (.*)/) { $1 }

    missing_deps = (all_core_deps - documented_deps).sort
    extra_deps = (documented_deps - all_core_deps).sort

    return if missing_deps.empty? && extra_deps.empty?

    missing_messages = missing_deps.map do |d|
      "Dependency \`#{d}\` should be documented in \`DEPENDENCIES.md\` with an explanation " \
        "as to why it is needed, and a link to the dependency's license"
    end
    extra_messages = extra_deps.map do |d|
      "Dependency \`#{d}\` is documented in \`DEPENDENCIES.md\` but we don't seem to depend " \
        "on it anymore"
    end
    puts (missing_messages + extra_messages)
    exit 1
  end
end
