platform :osx, '10.9'
use_frameworks!

def genumkit_pods
  pod 'PathKit', '~> 0.7.0', :inhibit_warnings => true
  pod 'Stencil', :git => 'https://github.com/kylef/Stencil', :inhibit_warnings => true
  pod 'GenumKit', :path => 'GenumKit'
end

target 'swiftgen' do
  pod 'Commander', '~> 0.6.0', :inhibit_warnings => true
  genumkit_pods()
end

target 'UnitTests' do
  genumkit_pods()
end

post_install do |installer|
  genumkit_target = installer.pod_targets.find { |target| target.name == 'GenumKit' }.native_target
  debug_config = genumkit_target.build_configurations.find { |config| config.name == 'Debug' }
  debug_config.build_settings['ENABLE_TESTABILITY'] = 'YES'
end
