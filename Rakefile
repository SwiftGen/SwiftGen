#!/usr/bin/rake

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

DEPENDENCIES = [:SwiftGenKit, :Commander]
CONFIGURATION = 'Release'
BUILD_DIR = 'build/' + CONFIGURATION



desc "Build the CLI binary and its Frameworks"
task :build => DEPENDENCIES do |_, args|
  frameworks = DEPENDENCIES.map { |fmk| "-framework #{fmk}" }.join(" ")
  xcrun %Q(-sdk macosx swiftc -O -o #{BUILD_DIR}/swiftgen -F #{BUILD_DIR}/ #{frameworks} swiftgen-cli/*.swift)
end

DEPENDENCIES.each do |fmk|
  # desc "Build #{fmk}.framework"
  task fmk do
    xcrun %Q(xcodebuild -project Pods/Pods.xcodeproj -target #{fmk} -configuration #{CONFIGURATION})
  end
end


desc "Build the CLI and Framework, and install them in $dir/bin and $dir/Frameworks"
task :install, [:dir] => :build do |_, args|
  args.with_defaults(:dir => '/usr/local')
  puts "== Installing to #{args.dir} =="
  sh %Q(mkdir -p "#{args.dir}/bin")
  sh %Q(cp -f "#{BUILD_DIR}/swiftgen" "#{args.dir}/bin/")
  sh %Q(mkdir -p "#{args.dir}/Frameworks")
  DEPENDENCIES.each do |fmk|
    sh %Q(cp -fr "#{BUILD_DIR}/#{fmk}.framework" "#{args.dir}/Frameworks/")
  end
  sh %Q(install_name_tool -add_rpath "@executable_path/../Frameworks" "#{args.dir}/bin/swiftgen")
  puts "\n  > Binary available in #{args.dir}/bin/swiftgen"
end

desc "Run the Unit Tests"
task :tests do
  xcrun %Q(xcodebuild -workspace SwiftGen.xcworkspace -scheme swiftgen-cli -sdk macosx test)
end

desc "Remove Rome/ and bin/"
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
  task :assets do
    sh %Q(#{dev_dir} xcrun actool --compile SwiftGen.playground/Resources --platform iphoneos --minimum-deployment-target 7.0 --output-format=human-readable-text UnitTests/fixtures/Images.xcassets)
  end
  task :storyboard do
    sh %Q(#{dev_dir} xcrun ibtool --compile SwiftGen.playground/Resources/Wizard.storyboardc --flatten=NO UnitTests/fixtures/Wizard.storyboard)
  end
  task :localizable do
    sh %Q(#{dev_dir} xcrun plutil -convert binary1 -o SwiftGen.playground/Resources/Localizable.strings UnitTests/fixtures/Localizable.strings)
  end

  desc "Regenerate all the Playground resources based on the test fixtures.\nThis compiles the needed fixtures and place them in SwiftGen.playground/Resources"
  task :resources => %w(clean assets storyboard localizable)
end

###########################################################
