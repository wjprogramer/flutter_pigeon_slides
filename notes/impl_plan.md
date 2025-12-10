# 實作展示規劃（草稿）

## 溝通方式範圍（不含 Web）
- 標準 Platform Channels（手寫）：
  - MethodChannel（請求/回應）
  - EventChannel（單向事件流）
  - BasicMessageChannel（雙向訊息，任意型別）
- Pigeon：以介面檔產生雙端碼，本質仍透過 StandardMessageCodec 的 platform channel。常用 API 角色：
  - HostApi：由原生端實作、Flutter 呼叫。
  - FlutterApi：由 Flutter 實作、原生端呼叫。
  - EventChannelApi：事件流（對應 EventChannel）。
  - ProxyApi：針對特定 proxy 的 API。
- dart:ffi：直接呼叫原生動態庫（C/C++），避開 platform channel 編解碼。

## 待討論/決策
- 各方式的 demo 功能/資料模型設計。
- 非 macOS 平台的「不支援」呈現策略。
- 產生碼與手寫碼的展示重點與範圍（PR diff/關鍵片段）。

## Demo 情境草案（覆蓋全部通道）
- 功能主題（單一資料模型，便於比較）：Counter
  - 查詢（MethodChannel / Pigeon HostApi / FFI 函數）：回傳 counter 整數或含 metadata 的物件（可含 enum/nullable，用於型別覆蓋）。
  - 更新（MethodChannel / Pigeon HostApi）：帶增量參數，回傳結果。
  - 事件（EventChannel / Pigeon EventChannelApi）：推送 counter 變化流。
  - 雙向訊息（BasicMessageChannel）：回聲/小訊息回覆，用於展示 Map/任意型別。
- Pigeon 覆蓋面：HostApi（macOS 實作）、FlutterApi（可選：原生回呼 Flutter）、EventChannelApi（狀態流）。
- FFI 覆蓋面：C 函式（如 get_counter / add_counter），示範跳過 channel 的呼叫與編解碼。
- 非 macOS 平台：統一 fallback（UI/訊息），但可展示產物或程式碼片段。

### Counter 資料模型（建議）
- 欄位固定一致：`value` (int)、`updatedAt` (int 時戳，可選)、`source` (enum: local/native/ffi，可選)；所有通道、所有測試用同一組欄位，保持可比性。

### API 設計對照
- MethodChannel / Pigeon HostApi：
  - `getCounter() -> Counter`
  - `increment(int delta) -> Counter`
  - （選擇性）`reset() -> Counter` 供批次量測前歸零
- EventChannel / Pigeon EventChannelApi：
  - 推送 `Counter` 或純 `value` 的 stream（可附 `source`）
- BasicMessageChannel：
  - `{"op":"echo","value":N}` 回傳相同 payload，展示 Map/任意型別傳遞
- FFI：
  - `int get_counter()`
  - `int add_counter(int delta)`

## 效能與量測計畫（草稿）
- 目標：比對 MethodChannel（手寫）、Pigeon（同功能）、dart:ffi 的延遲與吞吐。
- 方法：
  - 微基準：同一 payload（小/中/大）重複呼叫 N 次（如 10k），預熱後量測平均/中位數/尾延遲。
  - 測項：查詢（sync-like request/response）、設定（帶參數）、事件（EventChannel/Pigeon Event），以及 BasicMessageChannel 小訊息。
  - 計時：以端到端為主（T1 Flutter 發送、T4 Flutter 收到），同機同環境下比較方案延遲；若需拆段再加入 T2/T3（原生收到/回應）。
  - FFI 對照：同等功能的 C 函式，比較跳過 channel 的延遲。
  - 事件：記原生推送時間與 Flutter 收到時間（單向）。
  - BasicMessageChannel：端到端 T1~T4 量測即可，除非需要拆段才加 T2/T3。
- 產出：表格/圖示（平均、中位、P95）、簡短結論；記錄測試環境。

## 展示重點（可後續細化）
- 手寫 vs Pigeon：介面檔 vs 手寫通道樣板；PR diff 對照（命名/欄位）。
- 事件與雙向訊息：EventChannel vs Pigeon EventChannelApi；BasicMessageChannel 對照。
- FFI：展示跳過 channel 的路徑與適用場景。

（後續可逐項展開）***

