platform :osx, '10.9'
use_frameworks!

target 'swiftgen' do
  pod 'Commander', '~> 0.8'
  pod 'StencilSwiftKit', '~> 2.3'
  podspec :path => 'SwiftGenKit.podspec'
  pod 'Yams', '~> 0.3'

  target 'SwiftGen UnitTests' do
    inherit! :complete
  end

  target 'Templates UnitTests' do
    inherit! :complete
  end
end

target 'SwiftGenKit' do
  podspec :path => 'SwiftGenKit.podspec'

  target 'SwiftGenKit UnitTests' do
    inherit! :complete
  end
end

post_install do |installer|
  swift4_ready_pods = %w(PathKit Commander Yams)

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      version = swift4_ready_pods.include?(target.name) ? '4.0' : '3.2'
      config.build_settings['SWIFT_VERSION'] = version
    end
  end
end
