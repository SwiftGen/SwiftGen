# frozen_string_literal: true

require 'yaml'

COMPILATION_CONFIGURATION_FILE = 'compilation-configuration.yml'
MODULE_INPUT_PATH = 'Tests/Fixtures/CompilationEnvironment/Modules'
MODULE_OUTPUT_PATH = 'Tests/Fixtures/CompilationEnvironment'
TOOLCHAIN = 'com.apple.dt.toolchain.XcodeDefault'

# Define a Platform's associated sdk and target triple
#
class Platform
  private

  def initialize(sdk, target)
    @sdk = sdk
    @target = target
  end

  public

  attr_accessor :sdk, :target

  ALL = {
    'iOS' => Platform.new('iphoneos', 'arm64-apple-ios14.0'),
    'macOS' => Platform.new('macosx', 'x86_64-apple-macosx10.15'),
    'tvOS' => Platform.new('appletvos', 'arm64-apple-tvos14.0'),
    'watchOS' => Platform.new('watchos', 'armv7k-apple-watchos7.0')
  }.freeze

  SWIFT_VERSIONS = [4, 4.2, 5].freeze
end

# Helper methods to manipulate Swift Modules
#
class Module
  def self.commands_for_file(file, platform)
    platform = Platform::ALL[platform]

    Platform::SWIFT_VERSIONS.map do |swift_version|
      module_path = "#{MODULE_OUTPUT_PATH}/swift#{swift_version}/#{platform.sdk}"

      %(--toolchain #{TOOLCHAIN} -sdk #{platform.sdk} swiftc -swift-version #{swift_version} ) +
        %(-emit-module "#{MODULE_INPUT_PATH}/#{file}.swift" -module-name "#{file}" ) +
        %(-emit-module-path "#{module_path}" -target "#{platform.target}")
    end
  end

  def self.remove_swiftdoc
    Dir.glob("#{MODULE_OUTPUT_PATH}/*/*.swiftdoc").each do |file|
      FileUtils.rm_rf(file)
    end
  end

  def self.remove_swiftsourceinfo
    Dir.glob("#{MODULE_OUTPUT_PATH}/*/*.swiftsourceinfo").each do |file|
      FileUtils.rm_rf(file)
    end
  end
end

# Loads the `COMPILATION_CONFIGURATION_FILE` YAML files
# and use them to help determine the parameters to use when compiling a file
#
class CompilationConfiguration
  def self.load(folder)
    config_file = "#{folder}#{COMPILATION_CONFIGURATION_FILE}"
    YAML.load_file(config_file) if File.file?(config_file)
  end

  def commands_for_file(file)
    filename = File.basename(file)

    platforms(filename).flat_map do |platform|
      swift_versions(filename).map do |swift_version|
        module_path = "#{MODULE_OUTPUT_PATH}/swift#{swift_version}/#{platform.sdk}"
        definitions = definitions(filename).join(' ')
        extra_files = files(filename).join(' ')

        %(--toolchain #{TOOLCHAIN} -sdk #{platform.sdk} swiftc -swift-version #{swift_version} ) +
          %(-typecheck -target "#{platform.target}" -I "#{module_path}" #{definitions} ) +
          %(-module-name SwiftGen #{extra_files} #{file})
      end
    end
  end

  private

  def common
    @common || {}
  end

  def file_specific
    @file_specific || {}
  end

  def swift_versions(filename)
    get_value_for('swift_versions', filename, Platform::SWIFT_VERSIONS)
  end

  def platforms(filename)
    get_value_for('platforms', filename, Platform::ALL.keys).map do |platform|
      Platform::ALL[platform]
    end
  end

  def files(filename)
    get_value_for('files', filename, []).map do |file|
      "#{MODULE_OUTPUT_PATH}/#{file}"
    end
  end

  def definitions(filename)
    get_value_for('definitions', filename, []).map do |definition|
      "-D #{definition}"
    end
  end

  def get_value_for(key, filename, default)
    specific = file_specific.fetch(filename, {})
    specific.fetch(key, common.fetch(key, default))
  end
end
