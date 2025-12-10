import Cocoa
import FlutterMacOS
import Foundation

@main
class AppDelegate: FlutterAppDelegate {
  // MethodChannel state
  private var methodCounterValue: Int64 = 0
  private var methodCounterUpdatedAt: Int64 = 0

  // Pigeon state
  private var pigeonCounterValue: Int64 = 0
  private var pigeonCounterUpdatedAt: Int64 = 0

  private var eventSink: FlutterEventSink?
  private var pigeonWatchHandler: CounterWatchHandler?
  private var flutterApi: CounterFlutterApi?

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

  private func makeCounterPayload(value: Int64, updatedAt: Int64, source: String) -> [String: Any] {
    return [
      "value": value,
      "updatedAt": updatedAt,
      "source": source
    ]
  }

  private func notifyEvent(value: Int64, updatedAt: Int64, source: String) {
    eventSink?(makeCounterPayload(value: value, updatedAt: updatedAt, source: source))
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
        result(self.makeCounterPayload(value: self.methodCounterValue, updatedAt: self.methodCounterUpdatedAt, source: "method_channel"))
      case "increment":
        guard let args = call.arguments as? [String: Any], let delta = args["delta"] as? Int else {
          result(FlutterError(code: "bad-args", message: "Missing delta", details: nil))
          return
        }
        methodCounterValue += Int64(delta)
        methodCounterUpdatedAt = nowMs()
        let payload = makeCounterPayload(value: methodCounterValue, updatedAt: methodCounterUpdatedAt, source: "method_channel")
        notifyEvent(value: methodCounterValue, updatedAt: methodCounterUpdatedAt, source: "method_channel")
        result(payload)
      case "reset":
        methodCounterValue = 0
        methodCounterUpdatedAt = nowMs()
        let payload = makeCounterPayload(value: methodCounterValue, updatedAt: methodCounterUpdatedAt, source: "method_channel")
        notifyEvent(value: methodCounterValue, updatedAt: methodCounterUpdatedAt, source: "method_channel")
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

    let watchHandler = CounterWatchHandler { [weak self] in
      guard let self else { return Counter(value: 0, updatedAt: 0, source: "pigeon") }
      return Counter(value: self.pigeonCounterValue, updatedAt: self.pigeonCounterUpdatedAt, source: "pigeon")
    }
    WatchStreamHandler.register(with: messenger, streamHandler: watchHandler)
    pigeonWatchHandler = watchHandler

    flutterApi = CounterFlutterApi(binaryMessenger: messenger)
  }
}

extension AppDelegate: CounterHostApi {
  func getCounter() throws -> Counter {
    return Counter(value: pigeonCounterValue, updatedAt: pigeonCounterUpdatedAt, source: "pigeon")
  }

  func increment(delta: Int64) throws -> Counter {
    pigeonCounterValue += delta
    pigeonCounterUpdatedAt = nowMs()
    let counter = Counter(value: pigeonCounterValue, updatedAt: pigeonCounterUpdatedAt, source: "pigeon")
    notifyEvent(value: pigeonCounterValue, updatedAt: pigeonCounterUpdatedAt, source: "pigeon")
    pigeonWatchHandler?.push(counter)
    flutterApi?.onCounter(counter: counter, completion: { _ in })
    return counter
  }

  func reset() throws {
    pigeonCounterValue = 0
    pigeonCounterUpdatedAt = nowMs()
    let counter = Counter(value: pigeonCounterValue, updatedAt: pigeonCounterUpdatedAt, source: "pigeon")
    notifyEvent(value: pigeonCounterValue, updatedAt: pigeonCounterUpdatedAt, source: "pigeon")
    pigeonWatchHandler?.push(counter)
    flutterApi?.onCounter(counter: counter, completion: { _ in })
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

private class CounterWatchHandler: WatchStreamHandler {
  private var sink: PigeonEventSink<Counter>?
  private let currentValue: () -> Counter

  init(currentValue: @escaping () -> Counter) {
    self.currentValue = currentValue
  }

  override func onListen(withArguments arguments: Any?, sink: PigeonEventSink<Counter>) {
    self.sink = sink
    sink.success(currentValue())
  }

  override func onCancel(withArguments arguments: Any?) {
    sink = nil
  }

  func push(_ counter: Counter) {
    sink?.success(counter)
  }
}
