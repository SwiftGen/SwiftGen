Pod::Spec.new do |s|

  s.name         = "SwiftGenDataModel"
  s.version      = "1.0.0"
  s.summary      = "Helpers required by the code gen."

  s.homepage     = "https://github.com/AliSoftware/SwiftGen"
  s.license      = "MIT"
  s.author       = { "Olivier Halligon" => "olivier@halligon.net" }
  s.social_media_url = "https://twitter.com/aligatr"

  s.platform = :ios
  s.platform = :osx, '10.9'

  s.source       = { :git => "https://github.com/AliSoftware/SwiftGen.git", :tag => s.version.to_s }

  s.source_files = "**/*.swift"

  s.framework  = "Foundation"
end

