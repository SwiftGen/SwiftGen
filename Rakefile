#!/usr/bin/rake
require 'pathname'
require 'yaml'
require 'shellwords'


## [ Constants ] ##############################################################

WORKSPACE = 'SwiftGen'
SCHEME='swiftgen'
CONFIGURATION = 'Release'
BUILD_DIR = File.absolute_path('./build')
BIN_NAME = 'swiftgen'
TEMPLATES_SRC_DIR = 'Resources/templates'
POD_NAME = 'SwiftGen'


## [ Utils ] ##################################################################

def defaults(args)
  bindir = args.bindir.nil? || args.bindir.empty? ? (Pathname.new(BUILD_DIR) + 'swiftgen/bin') : Pathname.new(args.bindir)
  fmkdir = args.fmkdir.nil? || args.fmkdir.empty? ? bindir + '../lib' : Pathname.new(args.fmkdir)
  tpldir = args.tpldir.nil? || args.tpldir.empty? ? bindir + '../templates' : Pathname.new(args.tpldir)
  [bindir, fmkdir, tpldir].map(&:expand_path)
end

## [ Build Tasks ] ############################################################

desc "Build the CLI binary and its frameworks as an app bundle\n" \
     "(in #{BUILD_DIR})"
task :build, [:bindir, :tpldir] do |task, args|
  (bindir, _, tpldir) = defaults(args)
  tpl_rel_path = tpldir.relative_path_from(bindir)
  main = File.read('Sources/main.swift')
  File.write('Sources/main.swift', main.gsub(/^let templatesRelativePath = .*$/, %Q(let templatesRelativePath = "#{tpl_rel_path}")))

  Utils.print_info "Building Binary"
  plist_file = (Pathname.new(BUILD_DIR) + 'Build/Products/Release/swiftgen.app/Contents/Info.plist').to_s
  Utils.run(
    %Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{SCHEME}" -configuration "#{CONFIGURATION}") +
    %Q( -derivedDataPath "#{BUILD_DIR}" SWIFTGEN_OTHER_LDFLAGS="-sectcreate __TEXT __info_plist #{plist_file.shellescape}"),
    task, xcrun: true, formatter: :xcpretty)
end

desc "Install the binary in $bindir, frameworks in $fmkdir, and templates in $tpldir\n" \
     "(defaults $bindir=./build/swiftgen/bin/, $fmkdir=$bindir/../lib, $tpldir=$bindir/../templates"
task :install, [:bindir, :fmkdir, :tpldir] => :build do |_, args|
  (bindir, fmkdir, tpldir) = defaults(args)
  generated_bundle_path = "#{BUILD_DIR}/Build/Products/#{CONFIGURATION}/swiftgen.app/Contents"

  Utils.print_info "Installing binary in #{bindir}"
  Utils.run([
    %Q(mkdir -p "#{bindir}"),
    %Q(cp -f "#{generated_bundle_path}/MacOS/swiftgen" "#{bindir}/#{BIN_NAME}"),
  ], task, 'copy_binary')

  Utils.print_info "Installing frameworks in #{fmkdir}"
  Utils.run([
    %Q(([ -d "#{fmkdir}" ] && rm -rf "#{fmkdir}")),
    %Q(mkdir -p "#{fmkdir}"),
    %Q(cp -fR "#{generated_bundle_path}/Frameworks/" "#{fmkdir}"),
  ], task, 'copy_frameworks')

  Utils.print_info "Fixing binary's @rpath"
  Utils.run([
    %Q(install_name_tool -delete_rpath "@executable_path/../Frameworks" "#{bindir}/#{BIN_NAME}"),
    %Q(install_name_tool -add_rpath "@executable_path/#{fmkdir.relative_path_from(bindir)}" "#{bindir}/#{BIN_NAME}"),
  ], task, 'fix_rpath', xcrun: true)
 
  Utils.print_info "Installing templates in #{tpldir}"
  Utils.run([
    %Q(mkdir -p "#{tpldir}"),
    %Q(cp -r "#{TEMPLATES_SRC_DIR}/" "#{tpldir}"),
  ], task, 'copy_templates')

  Utils.print_info "Finished installing. Binary is available in: #{bindir}"
end


## [ Tests & Clean ] ##########################################################

desc "Run the Unit Tests"
task :tests do
  Utils.print_info "Running Unit Tests"
  Utils.run(%Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{SCHEME}" -sdk macosx test), task, xcrun: true, formatter: :xcpretty)
end

desc "Delete the build directory\n" \
     "(#{BUILD_DIR})"
task :clean do
  sh %Q(rm -fr #{BUILD_DIR})
end

task :default => [:build]



## [ Playground Resources ] ###################################################

namespace :playground do
  task :clean do
    sh 'rm -rf SwiftGen.playground/Resources'
    sh 'mkdir SwiftGen.playground/Resources'
  end
  task :images do
    Utils.run(%Q(actool --compile SwiftGen.playground/Resources --platform iphoneos --minimum-deployment-target 7.0 --output-format=human-readable-text Resources/Fixtures/Images/Images.xcassets), task, xcrun: true)
  end
  task :storyboard do
    Utils.run(%Q(ibtool --compile SwiftGen.playground/Resources/Wizard.storyboardc --flatten=NO Resources/Fixtures/Storyboards-iOS/Wizard.storyboard), task, xcrun: true)
  end
  task :strings do
    Utils.run(%Q(plutil -convert binary1 -o SwiftGen.playground/Resources/Localizable.strings Resources/Fixtures/Strings/Localizable.strings), task, xcrun: true)
  end

  desc "Regenerate all the Playground resources based on the test fixtures.\nThis compiles the needed fixtures and place them in SwiftGen.playground/Resources"
  task :resources => %w(clean images storyboard strings)
end
