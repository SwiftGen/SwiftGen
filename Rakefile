#!/usr/bin/rake
require 'pathname'
require 'yaml'


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
  Utils.run(%Q(xcodebuild -workspace #{WORKSPACE}.xcworkspace -scheme #{SCHEME} -configuration #{CONFIGURATION} -derivedDataPath #{BUILD_DIR}), task, xcrun: true, formatter: :xcpretty)
end

desc "Install the binary in $bindir, frameworks in $fmkdir, and templates in $tpldir\n" \
     "(defaults $bindir=./build/swiftgen/bin/, $fmkdir=$bindir/../lib, $tpldir=$bindir/../templates"
task :install, [:bindir, :fmkdir, :tpldir] => :build do |_, args|
  (bindir, fmkdir, tpldir) = defaults(args)
  generated_bundle_path = "#{BUILD_DIR}/Build/Products/#{CONFIGURATION}/swiftgen.app/Contents"

  Utils.print_info "Installing binary in #{bindir}"
  sh %Q(mkdir -p "#{bindir}")
  sh %Q(cp -f "#{generated_bundle_path}/MacOS/swiftgen" "#{bindir}/#{BIN_NAME}")

  Utils.print_info "Installing frameworks in #{fmkdir}"
  sh %Q(mkdir -p "#{fmkdir}")
  sh %Q(cp -fR "#{generated_bundle_path}/Frameworks/" "#{fmkdir}")

  Utils.print_info "Fixing @rpath to find frameworks"
  Utils.run(%Q(install_name_tool -delete_rpath "@executable_path/../Frameworks" "#{bindir}/#{BIN_NAME}"), task, xcrun: true)
  Utils.run(%Q(install_name_tool -add_rpath "@executable_path/#{fmkdir.relative_path_from(bindir)}" "#{bindir}/#{BIN_NAME}"), task, xcrun: true)
 
  Utils.print_info "Installing templates in #{tpldir}"
  sh %Q(mkdir -p "#{tpldir}")
  sh %Q(cp -r "#{TEMPLATES_SRC_DIR}/" "#{tpldir}")
end


## [ Tests & Clean ] ##########################################################

desc "Run the Unit Tests"
task :tests do
  Utils.print_info "Running Unit Tests"
  Utils.run(%Q(xcodebuild -workspace SwiftGen.xcworkspace -scheme swiftgen -sdk macosx test), task, xcrun: true, formatter: :xcpretty)
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
