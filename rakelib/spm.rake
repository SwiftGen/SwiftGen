# frozen_string_literal: true

# Used constants:
# none

if File.file?('Package.swift')
  namespace :spm do
    desc 'Build using SPM'
    task :build do |task|
      Utils.print_header 'Compile using SPM'
      Utils.run('swift build --enable-test-discovery', task, xcrun: true)
    end

    desc 'Run SPM Unit Tests'
    task :test => :build do |task|
      Utils.print_header 'Run the unit tests using SPM'
      Utils.run('swift test --enable-test-discovery', task, xcrun: true)
    end
  end
end
