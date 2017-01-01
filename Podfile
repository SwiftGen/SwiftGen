platform :osx, '10.9'
use_frameworks!

def common_pods
  pod 'PathKit', '~> 0.7.0', :inhibit_warnings => true
  pod 'Stencil', :git => 'https://github.com/kylef/Stencil', :inhibit_warnings => true
  pod 'StencilSwiftKit', :git => 'https://github.com/AliSoftware/StencilSwiftKit'
  pod 'SwiftGenKit', :git => 'https://github.com/AliSoftware/SwiftgenKit'
end

target 'swiftgen' do
  pod 'Commander', '~> 0.6.0', :inhibit_warnings => true
  common_pods()
end

target 'UnitTests' do
  common_pods()
end
