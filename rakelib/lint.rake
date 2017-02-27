namespace :lint do
  desc 'Install swiftlint'
  task :install do |task|
    swiftlint = `which swiftlint`
    
    if !(swiftlint && $?.success?)
      url = 'https://github.com/realm/SwiftLint/releases/download/0.16.1/SwiftLint.pkg'
      tmppath = '/tmp/SwiftLint.pkg'

      plain([
        "curl -Lo #{tmppath} #{url}",
        "sudo installer -pkg #{tmppath} -target /"
      ], task)
    end
  end
  
  desc 'Lint the code'
  task :code => :install do |task|
    print_info 'Linting the code'
    plain(%Q(swiftlint lint --no-cache --strict --path SwiftGen), task)
  end
end
