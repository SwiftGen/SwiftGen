#!/usr/bin/rake
require 'pathname'
require 'yaml'


## [ Constants ] ##############################################################

BIN_NAME = 'swiftgen'
DEPENDENCIES = [:PathKit, :Stencil, :Commander, :StencilSwiftKit, :SwiftGenKit]
CONFIGURATION = 'Release'
BUILD_DIR = 'build/' + CONFIGURATION
TEMPLATES_SRC_DIR = 'Resources/templates'
POD_NAME = 'SwiftGen'


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
  main = File.read('SwiftGen/main.swift')
  File.write('SwiftGen/main.swift', main.gsub(/^let templatesRelativePath = .*$/, %Q(let templatesRelativePath = "#{tpl_rel_path}")))

  print_info "Building Binary"
  frameworks = DEPENDENCIES.map { |fmk| "-framework #{fmk}" }.join(" ")
  search_paths = DEPENDENCIES.map { |fmk| "-F #{BUILD_DIR}/#{fmk}" }.join(" ")
  xcrun(%Q(-sdk macosx swiftc -O -o #{BUILD_DIR}/#{BIN_NAME} #{search_paths}/ #{frameworks} SwiftGen/*.swift), task)
end

namespace :dependencies do
  DEPENDENCIES.each do |fmk|
    # desc "Build #{fmk}.framework"
    task fmk do |task|
      print_info "Building #{fmk}.framework"
      xcrun(%Q(xcodebuild -project Pods/Pods.xcodeproj -target #{fmk} -configuration #{CONFIGURATION}), task)
    end
  end
end



## [ Install Tasks ] ##########################################################

desc "Install the binary in $bindir, frameworks — without the Swift dylibs — in $fmkdir, and templates in $tpldir\n" \
     "(defaults $bindir=./build/swiftgen/bin/, $fmkdir=$bindir/../lib, $tpldir=$bindir/../templates"
task 'install:light', [:bindir, :fmkdir, :tpldir] => :build do |_, args|
  (bindir, fmkdir, tpldir) = defaults(args)

  print_info "Installing binary in #{bindir}"
  sh %Q(mkdir -p "#{bindir}")
  sh %Q(cp -f "#{BUILD_DIR}/#{BIN_NAME}" "#{bindir}")

  print_info "Installing frameworks in #{fmkdir}"
  sh %Q(mkdir -p "#{fmkdir}")
  DEPENDENCIES.each do |fmk|
    sh %Q(cp -fr "#{BUILD_DIR}/#{fmk}/#{fmk}.framework" "#{fmkdir}")
  end
  sh %Q(install_name_tool -add_rpath "@executable_path/#{fmkdir.relative_path_from(bindir)}" "#{bindir}/#{BIN_NAME}")

  print_info "Installing templates in #{tpldir}"
  sh %Q(mkdir -p "#{tpldir}")
  sh %Q(cp -r "#{TEMPLATES_SRC_DIR}/" "#{tpldir}")
end

desc "Install the binary in $bindir, frameworks — including Swift dylibs — in $fmkdir, and templates in $tpldir\n" \
     "(defaults $bindir=./swiftgen/bin/, $fmkdir=$bindir/../lib, $tpldir=$bindir/../templates"
task :install, [:bindir, :fmkdir, :tpldir] => 'install:light' do |task, args|
  (bindir, fmkdir, tpldir) = defaults(args)

  print_info "Linking to standalone Swift dylibs"
  xcrun(%Q(swift-stdlib-tool --copy --scan-executable "#{bindir}/#{BIN_NAME}" --platform macosx --destination "#{fmkdir}"), task)
  toolchain_dir = `#{version_select} xcrun -find swift-stdlib-tool`.chomp
  xcode_rpath = File.dirname(File.dirname(toolchain_dir)) + '/lib/swift/macosx'
  xcrun(%Q(install_name_tool -delete_rpath "#{xcode_rpath}" "#{bindir}/#{BIN_NAME}"), task)
end



## [ Tests & Clean ] ##########################################################

desc "Run the Unit Tests"
task :tests do
  print_info "Running Unit Tests"
  xcrun(%Q(xcodebuild -workspace SwiftGen.xcworkspace -scheme swiftgen -sdk macosx test), task)
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
    xcrun(%Q(actool --compile SwiftGen.playground/Resources --platform iphoneos --minimum-deployment-target 7.0 --output-format=human-readable-text UnitTests/fixtures/Images.xcassets), task)
  end
  task :storyboard do
    xcrun(%Q(ibtool --compile SwiftGen.playground/Resources/Wizard.storyboardc --flatten=NO UnitTests/fixtures/Storyboards-iOS/Wizard.storyboard), task)
  end
  task :strings do
    xcrun(%Q(plutil -convert binary1 -o SwiftGen.playground/Resources/Localizable.strings UnitTests/fixtures/Localizable.strings), task)
  end

  desc "Regenerate all the Playground resources based on the test fixtures.\nThis compiles the needed fixtures and place them in SwiftGen.playground/Resources"
  task :resources => %w(clean images storyboard strings)
end
