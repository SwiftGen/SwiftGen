# Used constants:
# none

if File.file?('Package.swift')
    namespace :spm do
    desc 'Build using SPM'
    task :build do |task|
      Utils.print_info 'Compile using SPM'
      Utils.run('swift build', task, xcrun: true)
    end

    desc 'Run SPM Unit Tests'
    task :test => :build do |task|
      Utils.print_info 'Run the unit tests using SPM'
      Utils.run('swift test', task, xcrun: true)
    end
  end
end
