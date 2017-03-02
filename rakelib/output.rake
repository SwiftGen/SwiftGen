# Used constants:
# none

if File.directory? 'Tests/Expected'
  MODULE_INPUT_PATH = 'Fixtures/stub-env/Modules'
  MODULE_OUTPUT_PATH = 'Fixtures/stub-env'
  SDKS = {
    :macosx => 'x86_64-apple-macosx10.12',
    :iphoneos => 'armv7s-apple-ios10.0'
  }
  TOOLCHAINS = {
    :swift2 => {
      :module_path => "#{MODULE_OUTPUT_PATH}/swift2.3",
      :toolchain => 'com.apple.dt.toolchain.Swift_2_3'
    },
    :swift3 => {
      :module_path => "#{MODULE_OUTPUT_PATH}/swift3",
      :toolchain => 'com.apple.dt.toolchain.XcodeDefault'
    }
  }

  namespace :output do
    desc 'Compile modules'
    task :modules do |task|
      Utils.print_info 'Compile output modules'

      # macOS
      modules = ['PrefsWindowController']
      modules.each do |m|
        puts "Compiling module #{m}… (macos)"
        compile_module(m, :macosx, task)
      end

      # iOS
      modules = ['CustomSegue', 'LocationPicker', 'SlackTextViewController']
      modules.each do |m|
        puts "Compiling module #{m}… (ios)"
        compile_module(m, :iphoneos, task)
      end

      # delete swiftdoc
      Dir.glob("#{MODULE_OUTPUT_PATH}/*.swiftdoc").each do |f|
        FileUtils.rm_rf(f)
      end
    end

    desc 'Compile output'
    task :compile => :modules do |task|
      Utils.print_info 'Compiling template output files'

      exit Dir.glob('Tests/Expected/**/*.swift').map { |f|
        puts "Compiling #{f}…\n"
        compile_file(f, task)
      }.reduce(true) { |result, status|
        result && status
      }
    end

    def compile_module(m, sdk, task)
      target = SDKS[sdk]
      subtask = File.basename(m, '.*')
      commands = TOOLCHAINS.map do |key, toolchain|
        %Q(--toolchain #{toolchain[:toolchain]} -sdk #{sdk} swiftc -emit-module "#{MODULE_INPUT_PATH}/#{m}.swift" -module-name "#{m}" -emit-module-path "#{toolchain[:module_path]}" -target "#{target}")
      end

      Utils.run(commands, task, subtask, xcrun: true)
    end

    def compile_file(f, task)
      if f.match('swift3')
        toolchain = TOOLCHAINS[:swift3]
      else
        toolchain = TOOLCHAINS[:swift2]
      end

      if f.match('iOS')
        sdks = [:iphoneos]
      elsif f.match('macOS')
        sdks = [:macosx]
      else
        sdks = [:iphoneos, :macosx]
      end

      commands = sdks.map do |sdk|
        %Q(--toolchain #{toolchain[:toolchain]} -sdk #{sdk} swiftc -parse -target #{SDKS[sdk]} -I #{toolchain[:module_path]} "#{MODULE_OUTPUT_PATH}/Definitions.swift" #{f})
      end
      subtask = File.basename(f, '.*')

      begin
        Utils.run(commands, task, subtask, xcrun: true)
        return true
      rescue
        return false
      end
    end
  end
end
