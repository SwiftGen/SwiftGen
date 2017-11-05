platform :osx, '10.9'
use_frameworks!

def common_pods
  pod 'PathKit', '~> 0.8.0', inhibit_warnings: true
end

def code_generation_pods
  common_pods
  pod 'StencilSwiftKit', '~> 2.3'
end

def swiftgen_pods
  code_generation_pods
  pod 'SwiftGenKit', path: 'SwiftGenKit'
  pod 'Yams', '~> 0.3'
end

target 'swiftgen' do
  swiftgen_pods
  pod 'Commander', '~> 0.8'
end

target 'SwiftGen UnitTests' do
  swiftgen_pods
end

target 'SwiftGenKit UnitTests' do
  common_pods
  pod 'SwiftGenKit', path: 'SwiftGenKit'
end

target 'Templates UnitTests' do
  code_generation_pods
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
