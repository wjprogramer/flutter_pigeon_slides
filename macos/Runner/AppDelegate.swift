import Cocoa
import FlutterMacOS
import Foundation

@main
class AppDelegate: FlutterAppDelegate {
  private var counterValue: Int64 = 0
  private var counterUpdatedAt: Int64 = 0
  private var eventSink: FlutterEventSink?

  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    NSLog("AppDelegate applicationDidFinishLaunching start")
    // Channel setup is triggered from MainFlutterWindow.awakeFromNib
    // to ensure the FlutterViewController is fully initialized.
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  private func nowMs() -> Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
  }

  private func makeCounterPayload(source: String) -> [String: Any] {
    return [
      "value": counterValue,
      "updatedAt": counterUpdatedAt,
      "source": source
    ]
  }

  private func notifyEvent(source: String) {
    eventSink?(makeCounterPayload(source: source))
  }

  func configureChannels(controller: FlutterViewController) {
    let messenger = controller.engine.binaryMessenger
    NSLog("AppDelegate setUpChannels invoked")

    // MethodChannel demo
    let methodChannel = FlutterMethodChannel(
      name: "demo.counter.method",
      binaryMessenger: messenger
    )
    methodChannel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      NSLog("MethodChannel call: \(call.method)")
      switch call.method {
      case "getCounter":
        result(self.makeCounterPayload(source: "native_method"))
      case "increment":
        guard let args = call.arguments as? [String: Any], let delta = args["delta"] as? Int else {
          result(FlutterError(code: "bad-args", message: "Missing delta", details: nil))
          return
        }
        counterValue += Int64(delta)
        counterUpdatedAt = nowMs()
        let payload = makeCounterPayload(source: "native_method")
        notifyEvent(source: "native_method")
        result(payload)
      case "reset":
        counterValue = 0
        counterUpdatedAt = nowMs()
        let payload = makeCounterPayload(source: "native_method")
        notifyEvent(source: "native_method")
        result(payload)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    // BasicMessageChannel echo
    let messageChannel = FlutterBasicMessageChannel(
      name: "demo.counter.basic",
      binaryMessenger: messenger,
      codec: FlutterStandardMessageCodec.sharedInstance()
    )
    messageChannel.setMessageHandler { message, reply in
      reply(message)
    }

    // EventChannel
    let eventChannel = FlutterEventChannel(
      name: "demo.counter.events",
      binaryMessenger: messenger
    )
    eventChannel.setStreamHandler(self)
  }
}

extension AppDelegate: CounterHostApi {
  func getCounter() throws -> Counter {
    return Counter(value: counterValue, updatedAt: counterUpdatedAt, source: "pigeon")
  }

  func increment(delta: Int64) throws -> Counter {
    counterValue += delta
    counterUpdatedAt = nowMs()
    let counter = Counter(value: counterValue, updatedAt: counterUpdatedAt, source: "pigeon")
    notifyEvent(source: "pigeon")
    return counter
  }

  func reset() throws {
    counterValue = 0
    counterUpdatedAt = nowMs()
    notifyEvent(source: "pigeon")
  }
}

extension AppDelegate: FlutterStreamHandler {
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
