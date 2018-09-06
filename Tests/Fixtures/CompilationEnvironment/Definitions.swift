#if os(iOS)

import UIKit

final class CreateAccViewController: UIViewController {}
final class PickerViewController: UIViewController {}
final class SlideLeftSegue: UIStoryboardSegue {}
final class SlideUpSegue: UIStoryboardSegue {}

#if DEFINE_EXTRA_MODULE_TYPES
final class SlideDownSegue: UIStoryboardSegue {}
final class ValidatePasswordViewController: UIViewController {}
#elseif DEFINE_NAMESPACED_EXTRA_MODULE_TYPES
enum ExtraModule {
  final class SlideDownSegue: UIStoryboardSegue {}
  final class ValidatePasswordViewController: UIViewController {}
}
#endif

#elseif os(OSX)

import Cocoa

final class CustomTabViewController: NSWindowController {}
final class DetailsViewController: NSWindowController {}
final class RotateSegue: NSStoryboardSegue {}
final class ZoomSegue: NSStoryboardSegue {}

#if DEFINE_EXTRA_MODULE_TYPES
final class LoginSegue: NSStoryboardSegue {}
final class LoginViewController: NSWindowController {}
#elseif DEFINE_NAMESPACED_EXTRA_MODULE_TYPES
enum ExtraModule {
  final class LoginSegue: NSStoryboardSegue {}
  final class LoginViewController: NSWindowController {}
}
#endif

#endif
