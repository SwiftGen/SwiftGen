platform :osx, '10.9'
use_frameworks!

def common_pods
  pod 'SwiftGenKit', :git => 'git@github.com:SwiftGen/SwiftGenKit.git', :branch => 'feature/parser-protocol'
  pod 'PathKit', '~> 0.8.0', :inhibit_warnings => true
  pod 'Stencil', '~> 0.9.0', :inhibit_warnings => true
  pod 'StencilSwiftKit', :git => 'git@github.com:SwiftGen/StencilSwiftKit.git'
end

target 'swiftgen' do
  pod 'Commander', '~> 0.6.0', :inhibit_warnings => true
  common_pods
end

target 'UnitTests' do
  common_pods
end
