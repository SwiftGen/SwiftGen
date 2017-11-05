#if os(iOS)
  import UIKit

  class CreateAccViewController: UIViewController {
  }
  class XXPickerViewController: UIViewController {
  }
#elseif os(OSX)
  import Cocoa

  class CustomTabViewController: NSWindowController {
  }
  class NSControllerPlaceholder: NSWindowController {
  }
#endif
