platform :osx, '10.9'
use_frameworks!

target 'swiftgen' do
  pod 'Commander', '~> 0.4.1'
  pod 'PathKit', '~> 0.6.0'
  pod 'Stencil', :git => 'https://github.com/kylef/Stencil.git', :commit => 'f393efbd0bfe26ac26209d2d103907a3b5583f6b'
  pod 'SWXMLHash', '~> 2.5'
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
