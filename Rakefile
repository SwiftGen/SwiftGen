#!/usr/bin/rake
require 'pathname'

def dev_dir
  xcode7 = `mdfind 'kMDItemCFBundleIdentifier == com.apple.dt.Xcode && kMDItemVersion == "7.*"'`.split("\n")
  raise "\n[!!!] You need to have Xcode 7.x installed to compile the SwiftGen tools\n\n" if xcode7.empty?
  %Q(DEVELOPER_DIR=#{xcode7.last.shellescape})
end

def xcrun(cmd)
  full_cmd = "#{dev_dir} xcrun #{cmd}"
  if `which xcpretty` && $?.success?
    full_cmd = "set -o pipefail && #{full_cmd} | xcpretty -c"
  end
  sh full_cmd
end

###########################################################

BIN_NAME = 'swiftgen'
DEPENDENCIES = [:GenumKit, :Commander]
CONFIGURATION = 'Release'
BUILD_DIR = 'build/' + CONFIGURATION



desc "Build the CLI binary and its Frameworks in #{BUILD_DIR}"
task :build => DEPENDENCIES do |_, args|
  frameworks = DEPENDENCIES.map { |fmk| "-framework #{fmk}" }.join(" ")
  xcrun %Q(-sdk macosx swiftc -O -o #{BUILD_DIR}/#{BIN_NAME} -F #{BUILD_DIR}/ #{frameworks} swiftgen-cli/*.swift)
end

DEPENDENCIES.each do |fmk|
  # desc "Build #{fmk}.framework"
  task fmk do
    xcrun %Q(xcodebuild -project Pods/Pods.xcodeproj -target #{fmk} -configuration #{CONFIGURATION})
  end
end


desc "Install the binary in $bindir (defaults to /usr/local/bin) and the framework in $fmkdir (defaults to $bindir/../Frameworks)"
task :install, [:bindir,:fmkdir] => :build do |_, args|
  bindir = args.bindir.nil? || args.bindir.empty? ? Pathname.new('.') : Pathname.new(args.bindir)
  fmkdir = args.fmkdir.nil? || args.fmkdir.empty? ? bindir + '../Frameworks' : Pathname.new(args.fmkdir)
  
  puts "== Installing to #{bindir} =="
  sh %Q(mkdir -p "#{bindir}")
  sh %Q(cp -f "#{BUILD_DIR}/#{BIN_NAME}" "#{bindir}")
  sh %Q(mkdir -p "#{fmkdir}")
  DEPENDENCIES.each do |fmk|
    sh %Q(cp -fr "#{BUILD_DIR}/#{fmk}.framework" "#{fmkdir}")
  end
  sh %Q(install_name_tool -add_rpath "@executable_path/#{fmkdir.relative_path_from(bindir)}" "#{bindir}/#{BIN_NAME}")
  puts "\n  > Binary available in #{bindir}/#{BIN_NAME}"
end

desc "Run the Unit Tests"
task :tests do
  xcrun %Q(xcodebuild -workspace SwiftGen.xcworkspace -scheme swiftgen-cli -sdk macosx test)
end

desc "Delete the build/ directory"
task :clean do
  sh %Q(rm -fr build)
end

task :default => [:dependencies, :build]

###########################################################

namespace :playground do
  task :clean do
    sh 'rm -rf SwiftGen.playground/Resources'
    sh 'mkdir SwiftGen.playground/Resources'
  end
  task :images do
    sh %Q(#{dev_dir} xcrun actool --compile SwiftGen.playground/Resources --platform iphoneos --minimum-deployment-target 7.0 --output-format=human-readable-text UnitTests/fixtures/Images.xcassets)
  end
  task :storyboard do
    sh %Q(#{dev_dir} xcrun ibtool --compile SwiftGen.playground/Resources/Wizard.storyboardc --flatten=NO UnitTests/fixtures/Wizard.storyboard)
  end
  task :strings do
    sh %Q(#{dev_dir} xcrun plutil -convert binary1 -o SwiftGen.playground/Resources/Localizable.strings UnitTests/fixtures/Localizable.strings)
  end

  desc "Regenerate all the Playground resources based on the test fixtures.\nThis compiles the needed fixtures and place them in SwiftGen.playground/Resources"
  task :resources => %w(clean images storyboard strings)
end

###########################################################
