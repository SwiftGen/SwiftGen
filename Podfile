platform :osx, '10.9'
use_frameworks!

target 'swiftgen' do
  pod 'Commander'
  pod 'PathKit'
  pod 'Stencil', :git => 'https://github.com/AliSoftware/Stencil.git', :branch => 'guards' # Until Kyle merges my PRs
  pod 'GenumKit', :path => 'GenumKit'
end

target 'UnitTests' do
  pod 'GenumKit', :path => 'GenumKit'
end
