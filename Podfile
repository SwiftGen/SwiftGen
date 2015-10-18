platform :osx, '10.9'
use_frameworks!

target 'swiftgen' do
  pod 'Commander'
  pod 'PathKit'
  pod 'Stencil', :git => 'https://github.com/Kylef/Stencil.git', :branch => 'master' # Until Kyle releases a new version
  pod 'GenumKit', :path => 'GenumKit'
end

target 'UnitTests' do
  pod 'GenumKit', :path => 'GenumKit'
end
