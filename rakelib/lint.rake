# frozen_string_literal: true

# Used constants:
# - BUILD_DIR

namespace :lint do
  SWIFTLINT = 'rakelib/lint.sh'
  SWIFTLINT_VERSION = '0.51.0'

  task :install do |task| 
    next if check_version

    if OS.mac?
      url = "https://github.com/realm/SwiftLint/releases/download/#{SWIFTLINT_VERSION}/portable_swiftlint.zip"
    else
      url = "https://github.com/realm/SwiftLint/releases/download/#{SWIFTLINT_VERSION}/swiftlint_linux.zip"
    end
    tmppath = '/tmp/swiftlint.zip'
    destination = "#{BUILD_DIR}/swiftlint"

    Utils.run([
      %(curl -Lo #{tmppath} #{url}),
      %(rm -rf #{destination}),
      %(mkdir -p #{destination}),
      %(unzip #{tmppath} -d #{destination})
    ], task)
  end

  desc 'Lint the code'
  task :code => :install do |task|
    Utils.print_header 'Linting the code'
    Utils.run(%(#{SWIFTLINT} swiftgen_sources), task)
    Utils.run(%(#{SWIFTLINT} swiftgencli_sources), task)
    Utils.run(%(#{SWIFTLINT} swiftgenkit_sources), task)
  end

  desc 'Lint the tests'
  task :tests => :install  do |task|
    Utils.print_header 'Linting the unit test code'
    Utils.run(%(#{SWIFTLINT} testutils_sources), task)
    Utils.run(%(#{SWIFTLINT} swiftgen_tests), task)
    Utils.run(%(#{SWIFTLINT} swiftgenkit_tests), task)
    Utils.run(%(#{SWIFTLINT} templates_tests), task)
  end

  if File.directory?('Sources/TestUtils/Fixtures/Generated')
    desc 'Lint the output'
    task :output => :install  do |task|
      Utils.print_header 'Linting the template output code'
      Utils.run(%(#{SWIFTLINT} templates_generated), task)
    end
  end

  def check_version
    swiftlint = "#{BUILD_DIR}/swiftlint/swiftlint"
    return false unless File.executable?(swiftlint)

    current = `#{swiftlint} version`.chomp
    required = SWIFTLINT_VERSION.chomp

    current == required
  end
end
