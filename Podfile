platform :osx, '10.9'
use_frameworks!

def common_pods
  pod 'SwiftGenKit', '~> 2.1'
  pod 'PathKit', '~> 0.8.0', inhibit_warnings: true
  pod 'Stencil', '~> 0.9.0', inhibit_warnings: true
  pod 'StencilSwiftKit', '~> 2.1'
  pod 'Yams', '~> 0.3'
end

target 'swiftgen' do
  pod 'Commander', '~> 0.6.0', inhibit_warnings: true
  common_pods
end

target 'UnitTests' do
  common_pods
end
