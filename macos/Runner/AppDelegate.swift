import Cocoa
import FlutterMacOS
import Foundation

@main
class AppDelegate: FlutterAppDelegate {
  // MethodChannel state (short keys)
  private var methodCounterValue: Int64 = 0
  private var methodCounterUpdatedAt: Int64 = 0

  // MethodChannel state (long keys) - 獨立狀態以避免互相影響
  private var methodCounterLongValue: Int64 = 0
  private var methodCounterLongUpdatedAt: Int64 = 0

  // Pigeon state
  private var pigeonCounterValue: Int64 = 0
  private var pigeonCounterUpdatedAt: Int64 = 0

  private var methodEventSink: FlutterEventSink?
  private var pigeonWatchHandler: CounterWatchHandler?
  private var flutterApi: CounterFlutterApi?

  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
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

  // 使用短鍵以降低序列化負載
  private func makeCounterPayload(value: Int64, updatedAt: Int64) -> [String: Any] {
    return [
      "v": value,
      "t": updatedAt
    ]
  }

  private func notifyMethodEvent(value: Int64, updatedAt: Int64) {
    methodEventSink?(makeCounterPayload(value: value, updatedAt: updatedAt))
  }

  func configureChannels(controller: FlutterViewController) {
    let messenger = controller.engine.binaryMessenger

    // MethodChannel demo
    let methodChannel = FlutterMethodChannel(
      name: "demo.counter.method",
      binaryMessenger: messenger
    )
    let methodChannelLong = FlutterMethodChannel(
      name: "demo.counter.method.long",
      binaryMessenger: messenger
    )
    methodChannel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "getCounter":
        result(self.makeCounterPayload(value: self.methodCounterValue, updatedAt: self.methodCounterUpdatedAt))
      case "increment":
        guard let args = call.arguments as? [String: Any], let delta = args["delta"] as? Int else {
          result(FlutterError(code: "bad-args", message: "Missing delta", details: nil))
          return
        }
        methodCounterValue += Int64(delta)
        methodCounterUpdatedAt = nowMs()
        let payload = makeCounterPayload(value: methodCounterValue, updatedAt: methodCounterUpdatedAt)
        result(payload)
      case "reset":
        methodCounterValue = 0
        methodCounterUpdatedAt = nowMs()
        let payload = makeCounterPayload(value: methodCounterValue, updatedAt: methodCounterUpdatedAt)
        notifyMethodEvent(value: methodCounterValue, updatedAt: methodCounterUpdatedAt)
        result(payload)
      case "emitMethodEvents":
        guard let args = call.arguments as? [String: Any], let count = args["count"] as? Int else {
          result(FlutterError(code: "bad-args", message: "Missing count", details: nil))
          return
        }
        emitMethodEvents(count: count)
        result(nil)
      case "emitPigeonEvents":
        guard let args = call.arguments as? [String: Any], let count = args["count"] as? Int else {
          result(FlutterError(code: "bad-args", message: "Missing count", details: nil))
          return
        }
        emitPigeonWatchEvents(count: count)
        result(nil)
      case "emitPigeonWatchEvents":
        guard let args = call.arguments as? [String: Any], let count = args["count"] as? Int else {
          result(FlutterError(code: "bad-args", message: "Missing count", details: nil))
          return
        }
        emitPigeonWatchEvents(count: count)
        result(nil)
      case "emitPigeonFlutterEvents":
        guard let args = call.arguments as? [String: Any], let count = args["count"] as? Int else {
          result(FlutterError(code: "bad-args", message: "Missing count", details: nil))
          return
        }
        emitPigeonFlutterEvents(count: count)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    methodChannelLong.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "getCounter":
        result([
          "value": self.methodCounterLongValue,
          "updatedAt": self.methodCounterLongUpdatedAt
        ])
      case "increment":
        guard let args = call.arguments as? [String: Any], let delta = args["delta"] as? Int else {
          result(FlutterError(code: "bad-args", message: "Missing delta", details: nil))
          return
        }
        methodCounterLongValue += Int64(delta)
        methodCounterLongUpdatedAt = nowMs()
        result([
          "value": methodCounterLongValue,
          "updatedAt": methodCounterLongUpdatedAt
        ])
      case "reset":
        methodCounterLongValue = 0
        methodCounterLongUpdatedAt = nowMs()
        result([
          "value": methodCounterLongValue,
          "updatedAt": methodCounterLongUpdatedAt
        ])
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
      guard let self else { return Counter(value: 0, updatedAt: 0) }
      return Counter(value: self.pigeonCounterValue, updatedAt: self.pigeonCounterUpdatedAt)
    }
    WatchStreamHandler.register(with: messenger, streamHandler: watchHandler)
    pigeonWatchHandler = watchHandler

    flutterApi = CounterFlutterApi(binaryMessenger: messenger)
  }

  private func emitMethodEvents(count: Int) {
    guard count > 0 else { return }
    let ts = nowMs()
    let payload = makeCounterPayload(value: methodCounterValue, updatedAt: ts)
    for _ in 0..<count {
      methodEventSink?(payload)
    }
  }

  private func emitPigeonEvents(count: Int) {
    emitPigeonWatchEvents(count: count)
    emitPigeonFlutterEvents(count: count)
  }

  private func emitPigeonWatchEvents(count: Int) {
    guard count > 0 else { return }
    let ts = nowMs()
    let counter = Counter(value: pigeonCounterValue, updatedAt: ts)
    for _ in 0..<count {
      pigeonWatchHandler?.push(counter)
    }
  }

  private func emitPigeonFlutterEvents(count: Int) {
    guard count > 0 else { return }
    let ts = nowMs()
    let counter = Counter(value: pigeonCounterValue, updatedAt: ts)
    for _ in 0..<count {
      flutterApi?.onCounter(counter: counter, completion: { _ in })
    }
  }
}

extension AppDelegate: CounterHostApi {
  func getCounter() throws -> Counter {
    return Counter(value: pigeonCounterValue, updatedAt: pigeonCounterUpdatedAt)
  }

  func increment(delta: Int64) throws -> Counter {
    pigeonCounterValue += delta
    pigeonCounterUpdatedAt = nowMs()
    let counter = Counter(value: pigeonCounterValue, updatedAt: pigeonCounterUpdatedAt)
    return counter
  }

  func reset() throws {
    pigeonCounterValue = 0
    pigeonCounterUpdatedAt = nowMs()
    let counter = Counter(value: pigeonCounterValue, updatedAt: pigeonCounterUpdatedAt)
    pigeonWatchHandler?.push(counter)
    flutterApi?.onCounter(counter: counter, completion: { _ in })
  }

  func emitEvent() throws {
    // For protocol conformance; existing pigeonEmitEvents handles batch pushes.
  }
}

extension AppDelegate: FlutterStreamHandler {
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    methodEventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    methodEventSink = nil
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
