# Used constants:
# _none_

## [ Playground Resources ] ###################################################

namespace :playground do
  task :clean do
    sh 'rm -rf SwiftGen.playground/Resources'
    sh 'mkdir SwiftGen.playground/Resources'
  end
  task :xcassets do
    Utils.run(
      %(actool --compile SwiftGen.playground/Resources --platform iphoneos --minimum-deployment-target 11.0 ) +
        %(--output-format=human-readable-text Tests/Fixtures/Resources/XCAssets/*.xcassets),
      task,
      xcrun: true
    )
  end
  task :fonts do
    sh %(cp Tests/Fixtures/Resources/Fonts/Avenir.ttc SwiftGen.playground/Resources/)
    sh %(cp Tests/Fixtures/Resources/Fonts/ZapfDingbats.ttf SwiftGen.playground/Resources/)
  end
  task :ib do
    Utils.run(
      %(ibtool --compile SwiftGen.playground/Resources/Wizard.storyboardc --flatten=NO ) +
        %(Tests/Fixtures/Resources/IB-iOS/Wizard.storyboard),
      task,
      xcrun: true
    )
  end
  task :json do
    sh %(cp Tests/Fixtures/Resources/YAML/good/json.json SwiftGen.playground/Resources/)
  end
  task :plist do
    sh %(cp Tests/Fixtures/Resources/Plist/good/Info.plist SwiftGen.playground/Resources/TestInfo.plist)
    sh %(cp Tests/Fixtures/Resources/Plist/good/array.plist SwiftGen.playground/Resources/)
    sh %(cp Tests/Fixtures/Resources/Plist/good/dictionary.plist SwiftGen.playground/Resources/)
  end
  task :strings do
    Utils.run(
      %(plutil -convert binary1 -o SwiftGen.playground/Resources/Localizable.strings ) +
        %(Tests/Fixtures/Resources/Strings/Localizable.strings),
      task,
      xcrun: true
    )
  end

  desc "Regenerate all the Playground resources based on the test fixtures.\n" \
    'This compiles the needed fixtures and place them in SwiftGen.playground/Resources'
  task :resources => %w[clean xcassets fonts ib json plist strings]
end