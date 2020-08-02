# frozen_string_literal: true

# Used constants:
#  - WORKSPACE

require_relative 'compilation_configuration'

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

namespace :output do
  desc 'Compile modules'
  task :modules do |task|
    Utils.print_header 'Compile output modules'

    # appleTVOS
    modules = %w[ExtraModule Transformables]
    modules.each do |m|
      Utils.print_info "Compiling module #{m}… (appletvos)"
      compile_module(m, 'tvOS', task)
    end

    # iOS
    modules = %w[ExtraModule LocationPicker SlackTextViewController Transformables]
    modules.each do |m|
      Utils.print_info "Compiling module #{m}… (ios)"
      compile_module(m, 'iOS', task)
    end

    # macOS
    modules = %w[ExtraModule PrefsWindowController Transformables]
    modules.each do |m|
      Utils.print_info "Compiling module #{m}… (macos)"
      compile_module(m, 'macOS', task)
    end

    # watchOS
    modules = %w[ExtraModule Transformables]
    modules.each do |m|
      Utils.print_info "Compiling module #{m}… (watchos)"
      compile_module(m, 'watchOS', task)
    end

    # delete unneeded files
    Module.remove_swiftdoc
    Module.remove_swiftsourceinfo
  end

  desc 'Compile output'
  task :compile => :modules do |task|
    Utils.print_header 'Compiling template output files'

    failures = []
    Dir.glob('Tests/Fixtures/Generated/*/*/').each do |folder|
      Utils.print_info "Loading config for #{folder}…\n"
      config = CompilationConfiguration.load(folder)
      next if config.nil?

      Dir.glob("#{folder}*.swift").each do |file|
        Utils.print_info "Compiling #{file}…\n"
        failures << file unless compile_file(file, config, task)
      end
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

  def compile_module(module_name, sdk, task)
    commands = Module.commands_for_file(module_name, sdk)
    subtask = File.basename(module_name, '.*')

    Utils.run(commands, task, subtask, xcrun: true)
  end

  def compile_file(file_name, config, task)
    commands = config.commands_for_file(file_name)
    subtask = File.basename(file_name, '.*')

    begin
      Utils.run(commands, task, subtask, xcrun: true)
      true
    rescue StandardError
      Utils.print_error "Failed to compile #{file_name}!"
      false
    end
  end
end
