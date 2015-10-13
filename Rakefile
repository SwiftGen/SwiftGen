#!/usr/bin/rake

def dev_dir
  xcode7 = `mdfind 'kMDItemCFBundleIdentifier == com.apple.dt.Xcode && kMDItemVersion == "7.*"'`.split("\n")
  raise "\n[!!!] You need to have Xcode 7.x installed to compile the SwiftGen tools\n\n" if xcode7.empty?
  %Q(DEVELOPER_DIR=#{xcode7.last.shellescape})
end

def run(cmd)
  if verbose == true
    sh cmd # Verbose shell
  else
    puts cmd
    `#{cmd} 2>/dev/null` # Quiet shell
  end
end

###########################################################

desc "Build only the CLI binary"
task :cli do |_, args|
  run %Q(#{dev_dir} xcrun -sdk macosx swiftc -O -o bin/swiftgen -F Rome -framework Commander -framework SwiftGenKit swiftgen-cli/*.swift)
end

desc "Rebuild dependencies using CocoaPods-Rome"
task :dependencies do
  run %q(pod install)
end

desc "Build the CLI and Framework, and install them in $dir/bin and $dir/Frameworks"
task :install, [:dir] => [:dependencies, :cli] do |_, args|
  args.with_defaults(:dir => '/usr/local')
  run %Q(mkdir -p "#{args.dir}/bin")
  run %Q(cp -f "bin/swiftgen" "#{args.dir}/bin/")
  run %Q(mkdir -p "#{args.dir}/Frameworks")
  run %Q(cp -fr "Rome/" "#{args.dir}/Frameworks/")
  run %Q(install_name_tool -add_rpath "@executable_path/../Frameworks" "#{args.dir}/bin/swiftgen")
end

desc "Run the Unit Tests"
task :tests do
  run %Q(#{dev_dir} xcodebuild -project SwiftGen.xcodeproj -scheme SwiftGenTests -sdk macosx test)
end

desc "Remove Rome/ and bin/"
task :clean do
  run %Q(rm -fr Rome bin)
end

task :default => [:dependencies, :cli]

###########################################################

namespace :playground do
  task :clean do
    sh 'rm -rf SwiftGen.playground/Resources'
    sh 'mkdir SwiftGen.playground/Resources'
  end
  task :assets do
    sh %Q(#{dev_dir} xcrun actool --compile SwiftGen.playground/Resources --platform iphoneos --minimum-deployment-target 7.0 --output-format=human-readable-text Tests/Assets/fixtures/Images.xcassets)
  end
  task :storyboard do
    sh %Q(#{dev_dir} xcrun ibtool --compile SwiftGen.playground/Resources/Wizard.storyboardc --flatten=NO Tests/Storyboard/fixtures/Wizard.storyboard)
  end
  task :localizable do
    sh %Q(#{dev_dir} xcrun plutil -convert binary1 -o SwiftGen.playground/Resources/Localizable.strings Tests/L10n/fixtures/Localizable.strings)
  end

  desc "Regenerate all the Playground resources based on the test fixtures.\nThis compiles the needed fixtures and place them in SwiftGen.playground/Resources"
  task :resources => %w(clean assets storyboard localizable)
end

###########################################################
