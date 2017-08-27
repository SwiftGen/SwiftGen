#!/usr/bin/rake
require 'pathname'
require 'yaml'
require 'shellwords'

## [ Constants ] ##############################################################

WORKSPACE = 'SwiftGen'.freeze
SCHEME_NAME = 'swiftgen'.freeze
CONFIGURATION = 'Release'.freeze
POD_NAME = 'SwiftGen'.freeze
MIN_XCODE_VERSION = 8.3

BUILD_DIR = File.absolute_path('./build')
BIN_NAME = 'swiftgen'.freeze
TEMPLATES_SRC_DIR = 'Resources/templates'.freeze

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
    plist_file = (Pathname.new(BUILD_DIR) + "Build/Products/#{CONFIGURATION}/swiftgen.app/Contents/Info.plist").to_s
    Utils.run(
      %(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{SCHEME_NAME}" -configuration "#{CONFIGURATION}") +
      %( -derivedDataPath "#{BUILD_DIR}" TEMPLATE_PATH="#{tpl_rel_path}") +
      %( SWIFTGEN_OTHER_LDFLAGS="-sectcreate __TEXT __info_plist #{plist_file.shellescape}"),
      task, xcrun: true, formatter: :xcpretty
    )
  end

  desc "Install the binary in $bindir, frameworks in $fmkdir, and templates in $tpldir\n" \
       '(defaults $bindir=./build/swiftgen/bin/, $fmkdir=$bindir/../lib, $tpldir=$bindir/../templates'
  task :install, %i[bindir fmkdir tpldir] => :build do |task, args|
    (bindir, fmkdir, tpldir) = defaults(args)
    generated_bundle_path = "#{BUILD_DIR}/Build/Products/#{CONFIGURATION}/swiftgen.app/Contents"

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

## [ ChangeLog ] ##############################################################

namespace :changelog do
  LINKS_SECTION_TITLE = 'Changes in other SwiftGen modules'.freeze

  desc 'Add links to other CHANGELOGs in the topmost SwiftGen CHANGELOG entry'
  task :links do
    changelog = File.read('CHANGELOG.md')
    abort('Links seems to already exist for latest version entry') if /^### (.*)/.match(changelog)[1] == LINKS_SECTION_TITLE
    links = linked_changelogs(
      swiftgenkit: Utils.podfile_lock_version('SwiftGenKit'),
      stencilswiftkit: Utils.podfile_lock_version('StencilSwiftKit'),
      stencil: Utils.podfile_lock_version('Stencil'),
      templates: Dir.chdir('Resources') { `git describe --abbrev=0 --tags`.chomp }
    )
    changelog.sub!(/^##[^#].*$\n/, "\\0\n#{links}")
    File.write('CHANGELOG.md', changelog)
  end

  def linked_changelogs(swiftgenkit: nil, stencilswiftkit: nil, stencil: nil, templates: nil)
    <<-LINKS.gsub(/^\s*\|/, '')
      |### #{LINKS_SECTION_TITLE}
      |
      |* [SwiftGenKit #{swiftgenkit}](https://github.com/SwiftGen/SwiftGenKit/blob/#{swiftgenkit}/CHANGELOG.md)
      |* [StencilSwiftKit #{stencilswiftkit}](https://github.com/SwiftGen/StencilSwiftKit/blob/#{stencilswiftkit}/CHANGELOG.md)
      |* [Stencil #{stencil}](https://github.com/kylef/Stencil/blob/#{stencil}/CHANGELOG.md)
      |* [templates #{templates}](https://github.com/SwiftGen/templates/blob/#{templates}/CHANGELOG.md)
    LINKS
  end
end

## [ Playground Resources ] ###################################################

namespace :playground do
  task :clean do
    sh 'rm -rf SwiftGen.playground/Resources'
    sh 'mkdir SwiftGen.playground/Resources'
  end
  task :xcassets do
    Utils.run(
      %(actool --compile SwiftGen.playground/Resources --platform iphoneos --minimum-deployment-target 7.0 ) +
        %(--output-format=human-readable-text Resources/Fixtures/XCAssets/Images.xcassets),
      task,
      xcrun: true
    )
  end
  task :storyboard do
    Utils.run(
      %(ibtool --compile SwiftGen.playground/Resources/Wizard.storyboardc --flatten=NO ) +
        %(Resources/Fixtures/Storyboards-iOS/Wizard.storyboard),
      task,
      xcrun: true
    )
  end
  task :strings do
    Utils.run(
      %(plutil -convert binary1 -o SwiftGen.playground/Resources/Localizable.strings ) +
        %(Resources/Fixtures/Strings/Localizable.strings),
      task,
      xcrun: true
    )
  end

  desc "Regenerate all the Playground resources based on the test fixtures.\n" \
    'This compiles the needed fixtures and place them in SwiftGen.playground/Resources'
  task :resources => %w[clean xcassets storyboard strings]
end
