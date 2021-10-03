#!/usr/bin/rake
# frozen_string_literal: true

require 'pathname'
require 'yaml'
require 'shellwords'

if ENV['BUNDLE_GEMFILE'].nil?
  puts "\u{274C} Please use bundle exec"
  exit 1
end

## [ Constants ] ##############################################################

POD_NAME = 'SwiftGen'
MIN_XCODE_VERSION = 13.0
BUILD_DIR = File.absolute_path('./.build')

## [ Utils ] ##################################################################

def path(str)
  return nil if str.nil? || str.empty?

  Pathname.new(str)
end

def defaults(args)
  bindir = path(args.bindir) || (Pathname.new(BUILD_DIR) + 'swiftgen/bin')
  bindir.expand_path
end

## [ Build Tasks ] ############################################################

namespace :cli do
  desc "Build the CLI binary\n" \
    "(in #{BUILD_DIR})"
  task :build do |task, args|
    Utils.print_header 'Building Binary'
    Utils.run(
      %(swift build --disable-sandbox -c release --arch arm64 --arch x86_64),
      task, xcrun: true, formatter: :raw
    )
  end

  desc "Install the binary in $bindir\n" \
       "(defaults $bindir=#{BUILD_DIR}/swiftgen/bin/)"
  task :install, %i[bindir] => :build do |task, args|
    bindir = defaults(args)
    generated_binary_path = "#{BUILD_DIR}/apple/Products/Release/swiftgen"
    generated_bundle_path = "#{BUILD_DIR}/apple/Products/Release/SwiftGen_SwiftGenCLI.bundle"

    Utils.print_header "Installing binary in #{bindir}"
    Utils.run([
                %(mkdir -p "#{bindir}"),
                %(cp -f "#{generated_binary_path}" "#{bindir}/"),
                %(cp -Rf "#{generated_bundle_path}" "#{bindir}/")
              ], task, 'copy_binary')

    Utils.print_info "Finished installing. Binary is available in: #{bindir}"
  end

  desc "Delete the build directory\n" \
    "(#{BUILD_DIR})"
  task :clean do
    sh %(rm -fr #{BUILD_DIR}/swiftgen)
  end
end

task :default => 'cli:build'
