platform :osx, '10.9'
use_frameworks!

def common_pods
  pod 'SwiftGenKit', '~> 2.1'
  pod 'PathKit', '~> 0.8.0', inhibit_warnings: true
  pod 'Stencil', '~> 0.9.0', inhibit_warnings: true
  pod 'StencilSwiftKit', '~> 2.3'
  pod 'Yams', '~> 0.3'
end

target 'swiftgen' do
  pod 'Commander', '~> 0.8', inhibit_warnings: true
  common_pods
end

target 'UnitTests' do
  common_pods
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