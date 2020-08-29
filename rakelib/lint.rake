# frozen_string_literal: true

# Used constants:
# none

namespace :lint do
  SWIFTLINT = 'Scripts/SwiftLint.sh'

  desc 'Lint the code'
  task :code do |task|
    Utils.print_header 'Linting the code'
    Utils.run(%(#{SWIFTLINT} swiftgen_sources), task)
    Utils.run(%(#{SWIFTLINT} swiftgenkit_sources), task)
  end

  desc 'Lint the tests'
  task :tests do |task|
    Utils.print_header 'Linting the unit test code'
    Utils.run(%(#{SWIFTLINT} swiftgen_tests), task)
    Utils.run(%(#{SWIFTLINT} swiftgenkit_tests), task)
    Utils.run(%(#{SWIFTLINT} templates_tests), task)
  end

  if File.directory?('Tests/Fixtures/Generated')
    desc 'Lint the output'
    task :output do |task|
      Utils.print_header 'Linting the template output code'
      Utils.run(%(#{SWIFTLINT} templates_generated), task)
    end
  end
end
