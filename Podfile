platform :osx, '10.9'
use_frameworks!

target 'swiftgen' do
  pod 'Commander', '~> 0.6.0'
  pod 'PathKit', '~> 0.7.0'
  pod 'Stencil', '~> 0.7.2'
  pod 'GenumKit', :path => 'GenumKit'
end

target 'UnitTests' do
  pod 'GenumKit', :path => 'GenumKit'
end

post_install do |installer|
  genumkit_target = installer.pod_targets.find { |target| target.name == 'GenumKit' }.native_target
  debug_config = genumkit_target.build_configurations.find { |config| config.name == 'Debug' }
  debug_config.build_settings['ENABLE_TESTABILITY'] = 'YES'
end
