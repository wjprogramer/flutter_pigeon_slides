## FFI 主動通知 Flutter（筆記）

目標：原生 C/FFI 端主動推事件到 Flutter，不靠輪詢，也不混用 Platform Channel。

### 推薦方案（純 FFI + Dart Port）
- Dart 端開 `ReceivePort`，取得 `sendPort.nativePort` 傳給 C。
- C 端新增 `register_port(int64_t port)` 函式，儲存該 port。
- 事件發生時，C 端用 `Dart_PostCObject`（或等效 API）把資料推到該 port，Dart isolate 收到即為「原生→Flutter」通知。
- 優點：真正推播、不中途經過 Channel；缺點：需要些樣板碼、注意執行緒安全。

### 替代方案
- C → Swift/ObjC → EventChannel/FlutterApi：簡單，但不是純 FFI（混用 Channel）。
- FFI callback function pointer：Dart 端用 `Pointer.fromFunction` 傳 callback，C 端事件發生時呼叫。需確保回呼執行緒安全、不可拋 Dart 例外，通常要 marshal 回 main isolate。

### 待辦（若要導入）
- C：新增 `register_port`、持有 `Dart_Port`、在事件時 `Dart_PostCObject`。
- Dart：建立 `ReceivePort`，將 `nativePort` 傳給 C；在 listener 做事件處理/度量。

