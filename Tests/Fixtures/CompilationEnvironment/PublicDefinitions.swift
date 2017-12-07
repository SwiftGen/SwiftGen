#if os(iOS)
  import UIKit

  public class CreateAccViewController: UIViewController {
  }
  public class XXPickerViewController: UIViewController {
  }
#elseif os(OSX)
  import Cocoa

  public class CustomTabViewController: NSWindowController {
  }
  public class NSControllerPlaceholder: NSWindowController {
  }
#endif
