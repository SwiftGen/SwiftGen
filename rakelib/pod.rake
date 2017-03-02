# Used constants:
# - POD_NAME

if defined?(POD_NAME) && File.file?("#{POD_NAME}.podspec")
  namespace :pod do
    desc 'Lint the Pod'
    task :lint do |task|
      Utils.print_info 'Linting the pod spec'
      Utils.run(%Q(bundle exec pod lib lint "#{POD_NAME}.podspec" --quick), task)
    end
  end
end
