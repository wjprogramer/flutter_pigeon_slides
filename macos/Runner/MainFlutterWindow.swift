import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    if let appDelegate = NSApp.delegate as? AppDelegate {
      appDelegate.configureChannels(controller: flutterViewController)
      CounterHostApiSetup.setUp(
        binaryMessenger: flutterViewController.engine.binaryMessenger,
        api: appDelegate
      )
      NSLog("MainFlutterWindow configured custom channels and Pigeon APIs")
    } else {
      NSLog("MainFlutterWindow could not find AppDelegate to configure channels")
    }

    super.awakeFromNib()
  }
}
