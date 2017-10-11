# Used constants:
# - WORKSPACE

namespace :lint do
  SWIFTLINT_VERSION = '0.19.0'.freeze

  desc 'Install swiftlint'
  task :install do |task|
    next if check_version

    unless system('tty >/dev/null')
      puts "warning: Unable to install SwiftLint #{SWIFTLINT_VERSION} without a terminal." \
        "Please run 'bundle exec rake lint:install' from a terminal."
      next
    end

    url = "https://github.com/realm/SwiftLint/releases/download/#{SWIFTLINT_VERSION}/SwiftLint.pkg"
    tmppath = '/tmp/SwiftLint.pkg'

    Utils.run([
                "curl -Lo #{tmppath} #{url}",
                "sudo installer -pkg #{tmppath} -target /"
              ], task)
  end

  if File.directory?('Sources')
    desc 'Lint the code'
    task :code => :install do |task|
      Utils.print_header 'Linting the code'
      config = Pathname.getwd + '.swiftlint.yml'
      config = config.exist? ? "--config #{config}" : ''
      Utils.run(%(swiftlint lint --no-cache --strict --path Sources #{config}), task)
    end
  end

  desc 'Lint the tests'
  task :tests => :install do |task|
    Utils.print_header 'Linting the unit test code'
    config = Pathname.getwd + '.swiftlint.yml'
    config = config.exist? ? "--config #{config}" : ''
    Utils.run(%(swiftlint lint --no-cache --strict --path "Tests/#{WORKSPACE}Tests" #{config}), task)
  end

  if File.directory?('Tests/Expected')
    desc 'Lint the output'
    task :output => :install do |task|
      Utils.print_header 'Linting the template output code'
      config = Pathname.getwd + '.swiftlint.yml'
      config = config.exist? ? "--config #{config}" : ''
      Utils.run(%(swiftlint lint --no-cache --strict --path Tests/Expected #{config}), task)
    end
  end

  def check_version
    return false unless system('which swiftlint > /dev/null')

    current = `swiftlint version`.chomp.split('.').map(&:to_i)
    required = SWIFTLINT_VERSION.chomp.split('.').map(&:to_i)

    (current <=> required) >= 0
  end
end
