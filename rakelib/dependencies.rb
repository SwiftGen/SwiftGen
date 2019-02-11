require 'yaml'
require 'json'

# This compares the root dependencies in the Podfile.lock + the ones in SwiftGenKit.podspec
#   with the dependencies documented in DEPENDENCIES.md
#   and return any differences
#
# @return [(:missing => Array<String>, :extra => Array<String>)]
#         A Hash with 2 keys:
#          - `:missing` containing an array of the missing (undocumented) dependencies
#          - `extra` containing an array of extra dependencies (documented but non-existant)
def check_documented_dependencies()
  podfile_deps = YAML::load_file('Podfile.lock')['PODS'].map do |entry|
    key = entry.is_a?(Hash) && entry.count == 1 ? entry.keys.first : entry
    key.gsub(/ \([0-9.]*\)$/,'')
  end

  json_podpec = `bundle exec pod ipc spec SwiftGenKit.podspec`
  swiftgenkit_deps = JSON.parse(json_podpec)['dependencies'].keys

  all_core_deps = (podfile_deps + swiftgenkit_deps).uniq
  documented_deps = File.open('DEPENDENCIES.md').grep(/### (.*)/) { $1 }

  missing_deps = (all_core_deps - documented_deps).sort
  extra_deps = (documented_deps - all_core_deps).sort
  { :missing: missing_deps, :extra: extra_deps }
end
