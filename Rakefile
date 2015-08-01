#!/usr/bin/rake

def dev_dir
  xcode7 = `mdfind 'kMDItemCFBundleIdentifier == com.apple.dt.Xcode && kMDItemVersion == "7.*"'`.split("\n")
  raise "\n[!!!] You need to have Xcode 7.x installed to compile the SwiftGen tools\n\n" if xcode7.empty?
  %Q(DEVELOPER_DIR=#{xcode7.last.shellescape})
end

def build(files, output)
  files_list = files.flat_map { |pat| Dir["Sources/#{pat}"] }
  puts "\n== #{output} =="
  sh %Q(#{dev_dir} xcrun -sdk macosx swiftc -whole-module-optimization -o #{output} #{files_list.shelljoin})
end

def bintask(binary, src_folder)
  desc "Build #{binary} binary in bin/"
  task binary => :bin_dir do
    build(%W(Common/*.swift #{src_folder}/*.swift), "bin/#{binary}")
  end
end

###########################################################

task :bin_dir do
  `[ -d "./bin" ] || mkdir "./bin"`
end

desc 'Delete the bin/ directory'
task :clean do
  `rm -rf "./bin"`
end

bintask 'swiftgen-l10n', 'L10n'
bintask 'swiftgen-storyboard', 'Storyboard'
bintask 'swiftgen-colors', 'Colors'
bintask 'swiftgen-assets', 'Assets'

desc 'Build all executables in bin/'
task :all => %w(swiftgen-l10n swiftgen-storyboard swiftgen-colors swiftgen-assets)

desc 'clean + all'
task :default => [:clean, :all]


###########################################################

namespace :playground do
  task :assets do
    sh %Q(#{dev_dir} xcrun actool --compile SwiftGen.playground/Resources --platform iphoneos --minimum-deployment-target 7.0 Tests/Assets/fixtures/Images.xcassets)
  end
  task :storyboard do
    sh %Q(#{dev_dir} xcrun ibtool --compile SwiftGen.playground/Resources/Wizzard.storyboardc --flatten=NO Tests/Storyboard/fixtures/Wizzard.storyboard)
  end
  task :localizable do
    sh %Q(#{dev_dir} xcrun plutil --convert binary1 -o SwiftGen.playground/Resources/Localizable.strings Tests/L10n/fixtures/Localizable.strings)
  end

  desc 'Regenerate all the Playground resources based on the test fixtures'
  task :resources => %w(assets storyboard localizable)
end
###########################################################
