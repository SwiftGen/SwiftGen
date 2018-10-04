# Used constants:
#  - WORKSPACE

## [ Test Output Generation ] #################################################

namespace :generate do
  desc 'Generate Test Contexts'
  task :contexts => 'xcode:build' do |task|
    Utils.print_header 'Generating contexts...'
    Utils.run(
      %(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "SwiftGenKit - Generate Contexts" -configuration "#{CONFIGURATION}" test-without-building),
      task,
      xcrun: true,
      formatter: :xcpretty
    )
  end

  desc 'Generate Test Output'
  task :output => 'xcode:build' do |task|
    Utils.print_header 'Generating expected test output files...'
    Utils.run(
      %(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "Templates - Generate Output" -configuration "#{CONFIGURATION}" test-without-building),
      task,
      xcrun: true,
      formatter: :xcpretty
    )
  end
end

## [ Output compilation ] #####################################################

MODULE_INPUT_PATH = 'Tests/Fixtures/CompilationEnvironment/Modules'.freeze
MODULE_OUTPUT_PATH = 'Tests/Fixtures/CompilationEnvironment'.freeze
SDKS = {
  macosx: 'x86_64-apple-macosx10.13',
  iphoneos: 'arm64-apple-ios12.0',
  watchos: 'armv7k-apple-watchos5.0',
  appletvos: 'arm64-apple-tvos12.0'
}.freeze
TOOLCHAINS = {
  swift3: {
    version: '3',
    module_path: "#{MODULE_OUTPUT_PATH}/swift3",
    toolchain: 'com.apple.dt.toolchain.XcodeDefault'
  },
  swift4: {
    version: '4',
    module_path: "#{MODULE_OUTPUT_PATH}/swift4",
    toolchain: 'com.apple.dt.toolchain.XcodeDefault'
  },
  swift4_2: {
    version: '4.2',
    module_path: "#{MODULE_OUTPUT_PATH}/swift4",
    toolchain: 'com.apple.dt.toolchain.XcodeDefault'
  }
}.freeze

namespace :output do
  desc 'Compile modules'
  task :modules do |task|
    Utils.print_header 'Compile output modules'

    # macOS
    modules = %w[ExtraModule PrefsWindowController]
    modules.each do |m|
      Utils.print_info "Compiling module #{m}… (macos)"
      compile_module(m, :macosx, task)
    end

    # iOS
    modules = %w[ExtraModule LocationPicker SlackTextViewController]
    modules.each do |m|
      Utils.print_info "Compiling module #{m}… (ios)"
      compile_module(m, :iphoneos, task)
    end

    # delete swiftdoc
    Dir.glob("#{MODULE_OUTPUT_PATH}/*/*.swiftdoc").each do |f|
      FileUtils.rm_rf(f)
    end
  end

  desc 'Compile output'
  task :compile => :modules do |task|
    Utils.print_header 'Compiling template output files'

    failures = []
    Dir.glob('Tests/Fixtures/Generated/**/*.swift').each do |f|
      Utils.print_info "Compiling #{f}…\n"
      failures << f unless compile_file(f, task)
    end

    Utils.print_header 'Compilation report'
    if failures.empty?
      Utils.print_info 'All files compiled successfully!'
    else
      Utils.print_error 'The following files failed to compile'
      failures.each { |f| Utils.print_error " - #{f}" }
    end
    exit failures.empty?
  end

  def compile_module(m, sdk, task)
    target = SDKS[sdk]
    subtask = File.basename(m, '.*')
    commands = TOOLCHAINS.map do |_key, toolchain|
      %(--toolchain #{toolchain[:toolchain]} -sdk #{sdk} swiftc -swift-version #{toolchain[:version]} ) +
        %(-emit-module "#{MODULE_INPUT_PATH}/#{m}.swift" -module-name "#{m}" ) +
        %(-emit-module-path "#{toolchain[:module_path]}/#{sdk}" -target "#{target}")
    end

    Utils.run(commands, task, subtask, xcrun: true)
  end

  def toolchains(f)
    if f.include?('swift3')
      [TOOLCHAINS[:swift3]]
    elsif f.include?('swift4')
      [TOOLCHAINS[:swift4], TOOLCHAINS[:swift4_2]]
    else
      []
    end
  end

  def sdks(f)
    if f.include?('iOS')
      [:iphoneos]
    elsif f.include?('macOS')
      [:macosx]
    else
      %i[iphoneos macosx appletvos watchos]
    end
  end

  def files(f)
    if !(f.include?('iOS') || f.include?('macOS'))
      [f]
    elsif f.include?('public-access')
      ["#{MODULE_OUTPUT_PATH}/PublicDefinitions.swift", f]
    else
      ["#{MODULE_OUTPUT_PATH}/Definitions.swift", f]
    end
  end

  def flags(f)
    if f.include?('ignore-target-module-with-extra-module')
      ['-D', 'DEFINE_EXTRA_MODULE_TYPES']
    elsif f.include?('with-extra-module') || f.include?('no-defined-module')
      ['-D', 'DEFINE_NAMESPACED_EXTRA_MODULE_TYPES']
    else
      []
    end
  end

  def compile_file(f, task)
    toolchains = toolchains(f)
    if toolchains.nil? || toolchains.empty?
      puts "Unknown Swift toolchain for file #{f}"
      return true
    end
    sdks = sdks(f)
    files = files(f)
    flags = flags(f)

    commands = toolchains.flat_map do |toolchain|
      sdks.map do |sdk|
        %(--toolchain #{toolchain[:toolchain]} -sdk #{sdk} swiftc -swift-version #{toolchain[:version]} ) +
          %(-typecheck -target #{SDKS[sdk]} -I "#{toolchain[:module_path]}/#{sdk}" #{flags.join(' ')} ) +
          %(-module-name SwiftGen #{files.join(' ')})
      end
    end
    subtask = File.basename(f, '.*')

    begin
      Utils.run(commands, task, subtask, xcrun: true)
      return true
    rescue
      Utils.print_error "Failed to compile #{f}!"
      return false
    end
  end
end
