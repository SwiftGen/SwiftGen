# frozen_string_literal: true

# Used constants:
# _none_

require 'json'

namespace :spm do
  desc 'Build using SPM'
  task :build do |task|
    Utils.print_header 'Compile using SPM'
    Utils.run('swift build', task, xcrun: true)
  end

  desc 'Run SPM Unit Tests'
  task :test => :build do |task|
    Utils.print_header 'Run the unit tests using SPM'
    Utils.run('swift test --parallel', task, xcrun: true)
  end

  desc 'Update versions'
  task :update_versions, %i[swiftgen] do |task, args|
    args.with_defaults(:swiftgen => Utils.last_git_tag_version)
    swiftgen = args.swiftgen
    swiftgenkit = swiftgen
    stencil = Utils.spm_resolved_version('Stencil')
    stencilswiftkit = Utils.spm_resolved_version('StencilSwiftKit')

    versions = <<-VERSIONS.gsub(/^\s*\|/, '')
      |//
      |// SwiftGen
      |// Copyright © 2022 SwiftGen
      |// MIT Licence
      |//
      |
      |enum Version {
      |  static let swiftgen = "#{swiftgen}"
      |  static let swiftGenKit = "#{swiftgenkit}"
      |  static let stencil = "#{stencil}"
      |  static let stencilSwiftKit = "#{stencilswiftkit}"
      |}
    VERSIONS

    Utils.print_header 'Generating Sources/SwiftGen/Version.swift'
    File.write('Sources/SwiftGen/Version.swift', versions)
  end
end
