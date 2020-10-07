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

WORKSPACE = 'SwiftGen'
SCHEME_NAME = 'swiftgen'
CONFIGURATION = 'Debug'
RELEASE_CONFIGURATION = 'Release'
POD_NAME = 'SwiftGen'
MIN_XCODE_VERSION = 12.0

BUILD_DIR = File.absolute_path('./build')
BIN_NAME = 'swiftgen'
TEMPLATES_SRC_DIR = 'templates'

## [ Utils ] ##################################################################

def path(str)
  return nil if str.nil? || str.empty?

  Pathname.new(str)
end

def defaults(args)
  bindir = path(args.bindir) || (Pathname.new(BUILD_DIR) + 'swiftgen/bin')
  fmkdir = path(args.fmkdir) || (bindir + '../lib')
  tpldir = path(args.tpldir) || (bindir + '../templates')
  [bindir, fmkdir, tpldir].map(&:expand_path)
end

## [ Build Tasks ] ############################################################

namespace :cli do
  desc "Build the CLI binary and its frameworks as an app bundle\n" \
       "(in #{BUILD_DIR})"
  task :build, %i[bindir tpldir] do |task, args|
    (bindir, _, tpldir) = defaults(args)
    tpl_rel_path = tpldir.relative_path_from(bindir)

    Utils.print_header 'Building Binary'
    plist_file = (Pathname.new(BUILD_DIR) + "Build/Products/#{RELEASE_CONFIGURATION}/swiftgen.app/Contents/Info.plist").to_s

    # Ensure we have an Info.plist at the destination (Xcode 12 new build system's circular build dependencies detection seems to require this)
    FileUtils.mkdir_p File.dirname(plist_file)
    FileUtils.touch plist_file

    Utils.run(
      %(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{SCHEME_NAME}" -configuration "#{RELEASE_CONFIGURATION}") +
      %( -derivedDataPath "#{BUILD_DIR}" TEMPLATE_PATH="#{tpl_rel_path}") +
      %( SWIFTGEN_OTHER_LDFLAGS="-sectcreate __TEXT __info_plist #{plist_file.shellescape}") +
      # Note: "-Wl,-headerpad_max_install_names" is needed to fix a bug when Homebrew tries to update the dylib ID of linked frameworks
      #  - See: https://github.com/Homebrew/homebrew-core/pull/32403
      #  - See also: https://github.com/Carthage/Carthage/commit/899d8a5da15979fd0fede39fe57b56c7ff532abe for similar fix in Carthage's Makefile
      %( 'OTHER_LDFLAGS=$(inherited) -Wl,-headerpad_max_install_names' ),
      task, xcrun: true, formatter: :xcpretty
    )
  end

  desc "Install the binary in $bindir, frameworks in $fmkdir, and templates in $tpldir\n" \
       '(defaults $bindir=./build/swiftgen/bin/, $fmkdir=$bindir/../lib, $tpldir=$bindir/../templates'
  task :install, %i[bindir fmkdir tpldir] => :build do |task, args|
    (bindir, fmkdir, tpldir) = defaults(args)
    generated_bundle_path = "#{BUILD_DIR}/Build/Products/#{RELEASE_CONFIGURATION}/swiftgen.app/Contents"

    Utils.print_header "Installing binary in #{bindir}"
    Utils.run([
                %(mkdir -p "#{bindir}"),
                %(cp -f "#{generated_bundle_path}/MacOS/swiftgen" "#{bindir}/#{BIN_NAME}")
              ], task, 'copy_binary')

    Utils.print_header "Installing frameworks in #{fmkdir}"
    Utils.run([
                %(if [ -d "#{fmkdir}" ]; then rm -rf "#{fmkdir}"; fi),
                %(mkdir -p "#{fmkdir}"),
                %(cp -fR "#{generated_bundle_path}/Frameworks/" "#{fmkdir}")
              ], task, 'copy_frameworks')

    # HACK: remove swift libraries on 10.14.4 or higher, to avoid issues with brew
    macos_version = Gem::Version.new(`sw_vers -productVersion`)
    if macos_version >= Gem::Version.new('10.14.4')
      Utils.print_header "Removing bundled swift libraries from #{fmkdir}"
      Utils.run([
                  %(rm "#{fmkdir}"/libswift*.dylib)
                ], task, 'remove_bundled_swift')
    end

    Utils.print_header "Fixing binary's @rpath"
    Utils.run([
                %(install_name_tool -delete_rpath "@executable_path/../Frameworks" "#{bindir}/#{BIN_NAME}"),
                %(install_name_tool -add_rpath "@executable_path/#{fmkdir.relative_path_from(bindir)}" "#{bindir}/#{BIN_NAME}")
              ], task, 'fix_rpath', xcrun: true)

    Utils.print_header "Installing templates in #{tpldir}"
    Utils.run([
                %(mkdir -p "#{tpldir}"),
                %(cp -r "#{TEMPLATES_SRC_DIR}/" "#{tpldir}")
              ], task, 'copy_templates')

    Utils.print_info "Finished installing. Binary is available in: #{bindir}"
  end

  desc "Delete the build directory\n" \
     "(#{BUILD_DIR})"
  task :clean do
    sh %(rm -fr #{BUILD_DIR})
  end
end

task :default => 'cli:build'
