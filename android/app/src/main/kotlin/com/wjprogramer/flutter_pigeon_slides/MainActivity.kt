package com.wjprogramer.flutter_pigeon_slides

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import kotlin.system.measureTimeMillis

class MainActivity : FlutterActivity(), CounterHostApi {
  private var methodCounterValue: Long = 0
  private var methodCounterUpdatedAt: Long = 0

  private var pigeonCounterValue: Long = 0
  private var pigeonCounterUpdatedAt: Long = 0

  private var methodEventSink: EventChannel.EventSink? = null
  private var pigeonWatchHandler: CounterWatchHandler? = null
  private var flutterApi: CounterFlutterApi? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
  }

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    val messenger = flutterEngine.dartExecutor.binaryMessenger

    // MethodChannel demo
    val methodChannel = MethodChannel(messenger, "demo.counter.method")
    methodChannel.setMethodCallHandler(::handleMethodCall)

    // BasicMessageChannel echo
    val basicChannel = BasicMessageChannel<Any?>(messenger, "demo.counter.basic", StandardMessageCodec.INSTANCE)
    basicChannel.setMessageHandler { message, reply -> reply.reply(message) }

    // EventChannel (hand-written)
    val eventChannel = EventChannel(messenger, "demo.counter.events")
    eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        methodEventSink = events
      }

      override fun onCancel(arguments: Any?) {
        methodEventSink = null
      }
    })

    // Pigeon EventChannelApi
    val watchHandler = CounterWatchHandler { Counter(pigeonCounterValue, pigeonCounterUpdatedAt) }
    WatchStreamHandler.register(messenger, watchHandler)
    pigeonWatchHandler = watchHandler

    // Pigeon HostApi
    CounterHostApi.setUp(messenger, this)

    // Pigeon FlutterApi
    flutterApi = CounterFlutterApi(messenger)
  }

  private fun nowMs(): Long = System.currentTimeMillis()

  private fun makeCounterPayload(value: Long, updatedAt: Long): Map<String, Any> =
    mapOf("v" to value, "t" to updatedAt)

  private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "getCounter" -> result.success(makeCounterPayload(methodCounterValue, methodCounterUpdatedAt))
      "increment" -> {
        val delta = (call.argument<Number>("delta") ?: 0).toLong()
        methodCounterValue += delta
        methodCounterUpdatedAt = nowMs()
        result.success(makeCounterPayload(methodCounterValue, methodCounterUpdatedAt))
      }
      "reset" -> {
        methodCounterValue = 0
        methodCounterUpdatedAt = nowMs()
        notifyMethodEvent(methodCounterValue, methodCounterUpdatedAt)
        result.success(makeCounterPayload(methodCounterValue, methodCounterUpdatedAt))
      }
      "emitMethodEvents" -> {
        val count = (call.argument<Number>("count") ?: 0).toInt()
        emitMethodEvents(count)
        result.success(null)
      }
      "emitPigeonEvents" -> {
        val count = (call.argument<Number>("count") ?: 0).toInt()
        emitPigeonEvents(count)
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  private fun notifyMethodEvent(value: Long, updatedAt: Long) {
    methodEventSink?.success(makeCounterPayload(value, updatedAt))
  }

  private fun emitMethodEvents(count: Int) {
    if (count <= 0) return
    val payload = makeCounterPayload(methodCounterValue, nowMs())
    repeat(count) { methodEventSink?.success(payload) }
  }

  private fun emitPigeonEvents(count: Int) {
    if (count <= 0) return
    val counter = Counter(pigeonCounterValue, nowMs())
    repeat(count) {
      pigeonWatchHandler?.push(counter)
      flutterApi?.onCounter(counter) { }
    }
  }

  // CounterHostApi impl (Pigeon)
  override fun getCounter(): Counter = Counter(pigeonCounterValue, pigeonCounterUpdatedAt)

  override fun increment(delta: Long): Counter {
    pigeonCounterValue += delta
    pigeonCounterUpdatedAt = nowMs()
    return Counter(pigeonCounterValue, pigeonCounterUpdatedAt)
  }

  override fun reset() {
    pigeonCounterValue = 0
    pigeonCounterUpdatedAt = nowMs()
    val counter = Counter(pigeonCounterValue, pigeonCounterUpdatedAt)
    pigeonWatchHandler?.push(counter)
    flutterApi?.onCounter(counter) { }
  }
}
