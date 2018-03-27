# Used constants:
# none

namespace :lint do
  SWIFTLINT = 'Pods/SwiftLint/swiftlint'

  desc 'Lint the code'
  task :code do |task|
    Utils.print_header 'Linting the code'
    config = Pathname.getwd + '.swiftlint.yml'
    Utils.run(%(#{SWIFTLINT} lint --strict --path Sources --config "#{config}"), task)
  end

  desc 'Lint the tests'
  task :tests do |task|
    Utils.print_header 'Linting the unit test code'
    config = Pathname.getwd + '.swiftlint.yml'
    Dir.glob("Tests/*Tests").each { |folder|
      Utils.run(%(#{SWIFTLINT} lint --strict --path "#{folder}" --config "#{config}"), task)
    }
  end

  if File.directory?('Tests/Fixtures/Generated')
    desc 'Lint the output'
    task :output do |task|
      Utils.print_header 'Linting the template output code'
      config = Pathname.getwd + '.swiftlint.yml'
      Utils.run(%(#{SWIFTLINT} lint --strict --path Tests/Fixtures/Generated --config "#{config}"), task)
    end
  end
end
