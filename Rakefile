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

## [ Build Tasks ] ############################################################

namespace :cli do
  desc "Build the CLI binary\n" \
    "(in #{BUILD_DIR})"
  task :build, %[universal] do |task, args|
    args.with_defaults(universal: false)

    Utils.print_header 'Building Binary'
    archs = args.universal ? '--arch arm64 --arch x86_64' : ''
    Utils.run(%(swift build --disable-sandbox -c release #{archs}), task, xcrun: true, formatter: :raw)
  end

  desc "Install the binary in $bindir\n" \
       "(defaults $bindir=#{BUILD_DIR}/swiftgen/bin/)"
  task :install, %i[bindir universal] => :build do |task, args|
    args.with_defaults(bindir: "#{BUILD_DIR}/swiftgen/bin/", universal: false)

    bindir = Pathname.new(args.bindir).expand_path
    actual_build_dir = args.universal ? "#{BUILD_DIR}/apple/Products/Release" : "#{BUILD_DIR}/release"
    generated_binary_path = "#{actual_build_dir}/swiftgen"
    generated_bundle_path = "#{actual_build_dir}/SwiftGen_SwiftGenCLI.bundle"

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
