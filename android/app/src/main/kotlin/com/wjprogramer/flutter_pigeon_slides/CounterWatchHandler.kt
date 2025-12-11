package com.wjprogramer.flutter_pigeon_slides

class CounterWatchHandler(private val currentValue: () -> Counter) : WatchStreamHandler() {
  private var sink: PigeonEventSink<Counter>? = null

  override fun onListen(p0: Any?, sink: PigeonEventSink<Counter>) {
    this.sink = sink
    sink.success(currentValue())
  }

  override fun onCancel(p0: Any?) {
    sink = null
  }

  fun push(counter: Counter) {
    sink?.success(counter)
  }
}

