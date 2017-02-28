#!/usr/bin/rake
require 'pathname'
require 'yaml'


## [ Constants ] ##############################################################

BIN_NAME = 'swiftgen'
DEPENDENCIES = [:PathKit, :Stencil, :Commander, :StencilSwiftKit, :SwiftGenKit]
CONFIGURATION = 'Release'
BUILD_DIR = File.absolute_path('build/' + CONFIGURATION)
TEMPLATES_SRC_DIR = 'Resources/templates'
POD_NAME = 'SwiftGen'
TEST_PATH = "Tests/#{POD_NAME}Tests"


## [ Utils ] ##################################################################

def defaults(args)
  bindir = args.bindir.nil? || args.bindir.empty? ? Pathname.new('./build/swiftgen/bin') : Pathname.new(args.bindir)
  fmkdir = args.fmkdir.nil? || args.fmkdir.empty? ? bindir + '../lib' : Pathname.new(args.fmkdir)
  tpldir = args.tpldir.nil? || args.tpldir.empty? ? bindir + '../templates' : Pathname.new(args.tpldir)
  [bindir, fmkdir, tpldir].map(&:expand_path)
end

## [ Build Tasks ] ############################################################

desc "Build the CLI binary and its frameworks in #{BUILD_DIR}"
task :build, [:bindir, :tpldir] => DEPENDENCIES.map { |dep| "dependencies:#{dep}" } do |task, args|
  (bindir, _, tpldir) = defaults(args)
  tpl_rel_path = tpldir.relative_path_from(bindir)
  main = File.read('Sources/main.swift')
  File.write('Sources/main.swift', main.gsub(/^let templatesRelativePath = .*$/, %Q(let templatesRelativePath = "#{tpl_rel_path}")))

  Utils.print_info "Building Binary"
  frameworks = DEPENDENCIES.map { |fmk| "-framework #{fmk}" }.join(" ")
  search_paths = DEPENDENCIES.map { |fmk| %Q(-F "#{BUILD_DIR}/#{fmk}") }.join(" ")
  Utils.run(%Q(-sdk macosx swiftc -O -o "#{BUILD_DIR}/#{BIN_NAME}" #{search_paths}/ #{frameworks} Sources/*.swift -Xlinker -sectcreate -Xlinker __TEXT -Xlinker __info_plist -Xlinker "Sources/Info.plist"), task, xcrun: true)
end

namespace :dependencies do
  DEPENDENCIES.each do |fmk|
    # desc "Build #{fmk}.framework"
    task fmk do |task|
      Utils.print_info "Building #{fmk}.framework"
      Utils.run(%Q(xcodebuild -project Pods/Pods.xcodeproj -target #{fmk} -configuration #{CONFIGURATION}), task, xcrun: true, xcpretty: true)
    end
  end
end



## [ Install Tasks ] ##########################################################

desc "Install the binary in $bindir, frameworks — without the Swift dylibs — in $fmkdir, and templates in $tpldir\n" \
     "(defaults $bindir=./build/swiftgen/bin/, $fmkdir=$bindir/../lib, $tpldir=$bindir/../templates"
task 'install:light', [:bindir, :fmkdir, :tpldir] => :build do |_, args|
  (bindir, fmkdir, tpldir) = defaults(args)

  Utils.print_info "Installing binary in #{bindir}"
  sh %Q(mkdir -p "#{bindir}")
  sh %Q(cp -f "#{BUILD_DIR}/#{BIN_NAME}" "#{bindir}")

  Utils.print_info "Installing frameworks in #{fmkdir}"
  sh %Q(mkdir -p "#{fmkdir}")
  DEPENDENCIES.each do |fmk|
    sh %Q(cp -fr "#{BUILD_DIR}/#{fmk}/#{fmk}.framework" "#{fmkdir}")
  end
  sh %Q(install_name_tool -add_rpath "@executable_path/#{fmkdir.relative_path_from(bindir)}" "#{bindir}/#{BIN_NAME}")

  Utils.print_info "Installing templates in #{tpldir}"
  sh %Q(mkdir -p "#{tpldir}")
  sh %Q(cp -r "#{TEMPLATES_SRC_DIR}/" "#{tpldir}")
end

desc "Install the binary in $bindir, frameworks — including Swift dylibs — in $fmkdir, and templates in $tpldir\n" \
     "(defaults $bindir=./swiftgen/bin/, $fmkdir=$bindir/../lib, $tpldir=$bindir/../templates"
task :install, [:bindir, :fmkdir, :tpldir] => 'install:light' do |task, args|
  (bindir, fmkdir, tpldir) = defaults(args)

  Utils.print_info "Linking to standalone Swift dylibs"
  Utils.run(%Q(swift-stdlib-tool --copy --scan-executable "#{bindir}/#{BIN_NAME}" --platform macosx --destination "#{fmkdir}"), task, xcrun: true)
  toolchain_dir = Utils.run('-find swift-stdlib-tool', task, xcrun: true, direct: true).chomp
  xcode_rpath = File.dirname(File.dirname(toolchain_dir)) + '/lib/swift/macosx'
  Utils.run(%Q(install_name_tool -delete_rpath "#{xcode_rpath}" "#{bindir}/#{BIN_NAME}"), task, xcrun: true)
end



## [ Tests & Clean ] ##########################################################

desc "Run the Unit Tests"
task :tests do
  Utils.print_info "Running Unit Tests"
  Utils.run(%Q(xcodebuild -workspace SwiftGen.xcworkspace -scheme swiftgen -sdk macosx test), task, xcrun: true, xcpretty: true)
end

desc "Delete the build/ directory"
task :clean do
  sh %Q(rm -fr build)
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
