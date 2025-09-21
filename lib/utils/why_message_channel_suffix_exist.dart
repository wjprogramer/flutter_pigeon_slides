const whyMessageChannelSuffixExistContent = '''🦄 為什麼需要 `messageChannelSuffix`？

(ChatGPT 回答)

短答案：**為了「同一份 API，有多個獨立通道」的情境做命名空間隔離**，避免通道名稱衝突，並支援多實例／多引擎／測試等進階用法。

---

## 為什麼需要 `messageChannelSuffix`？

Pigeon 會為每個方法建立固定的 channel 名稱；但在以下情況，你可能需要**多組互不干擾的通道**：

1. **多實例（multi-instance）**
- 同一個 API 需要同時綁定多個「裝置/會話/連線」。
- 透過在 Dart 和原生兩側都指定相同的 suffix，就能把訊息路由到對應的那一組 handler，而不互相干擾。
2. **多 FlutterEngine / 多 Isolate**
- App 內同時啟動多個 `FlutterEngine` 或在 background isolate 執行任務。
- 用 suffix（例如帶上 engineId / isolateId）避免不同引擎的 channel 名稱互撞。
3. **依情境分流（前景/背景、前台/後台）**
- 例如把「一般操作」與「背景長任務」分別掛在不同的 handler；用不同 suffix 做乾淨的分隔。
4. **整合測試／單元測試**
- 測試時可加測試用 suffix，避免與正式執行的 channel 名稱衝突，或同機並行多組測試。
5. **漸進式遷移／版本併存**
- 新舊版 API 在一段時間內並存；以不同 suffix（如 `v1` / `v2`）共存而不互相踩到。

---

## 它實際做了什麼？

- Dart 端建構子接受 `messageChannelSuffix`；非空時，**在既有 channel 名稱尾端加上一個「`.` + suffix」**。
- 原生端（Kotlin/Swift）Pigeon 生成的 `setUp(...)` 也有對應的參數（或提供帶 suffix 的註冊方法）。
- **只有 Dart 與原生兩邊都使用相同 suffix**，這組 channel 才會連得上；否則會互相「聽不到」。

> 你看到的程式裡把 `''` 處理成空字串，不加點；非空才會自動加「`.` + suffix」，這就是為了保持傳統預設名稱不變，必要時才做命名空間化。

---

## 什麼時候「不必」用？

- 只有單一引擎、單一實例、單一流程；沒有通道名稱衝突風險時，就用預設空字串即可。

---

## 心智模型一句話

**`messageChannelSuffix` = 通道的命名空間**：用相同的 API schema，在不同情境（多實例/多引擎/測試/版本）各自掛一套 handler，彼此不搶同一條線。''';