namespace :lint do
  desc 'Install swiftlint'
  task :install do |task|
    if !system('which swiftlint > /dev/null')
      url = 'https://github.com/realm/SwiftLint/releases/download/0.16.1/SwiftLint.pkg'
      tmppath = '/tmp/SwiftLint.pkg'

      Utils.run([
        "curl -Lo #{tmppath} #{url}",
        "sudo installer -pkg #{tmppath} -target /"
      ], task)
    end
  end
  
  desc 'Lint the code'
  task :code => :install do |task|
    Utils.print_info 'Linting the code'
    Utils.run(%Q(swiftlint lint --no-cache --strict --path SwiftGen), task)
  end
end
