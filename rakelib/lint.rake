# Used constants:
# - WORKSPACE

namespace :lint do
  SWIFTLINT_VERSION = '0.19.0'

  desc 'Install swiftlint'
  task :install do |task|
    next if check_version()

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
      Utils.run(%Q(swiftlint lint --no-cache --strict --path Sources), task)
    end
  end
  
  desc 'Lint the tests'
  task :tests => :install do |task|
    Utils.print_header 'Linting the unit test code'
    Utils.run(%Q(swiftlint lint --no-cache --strict --path "Tests/#{WORKSPACE}Tests"), task)
  end
  
  if File.directory?('Tests/Expected')
    desc 'Lint the output'
    task :output => :install do |task|
      Utils.print_header 'Linting the template output code'
      Utils.run(%Q(swiftlint lint --no-cache --strict --path Tests/Expected), task)
    end
  end

  def check_version
    return false if not system('which swiftlint > /dev/null')

    current = `swiftlint version`.chomp.split('.').map { |e| e.to_i }
    required = SWIFTLINT_VERSION.chomp.split('.').map { |e| e.to_i }

    return (current <=> required) >= 0
  end
end
