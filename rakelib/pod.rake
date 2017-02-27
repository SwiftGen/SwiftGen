namespace :pod do
  desc 'Lint the Pod'
  task :lint do |task|
  	print_info 'Linting the pod spec'
    plain(%Q(pod lib lint "#{POD_NAME}.podspec" --quick), task)
  end
end
