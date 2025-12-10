# flutter_pigeon_slides

這是一份 Flutter 簡報/示範專案，用來分享「Flutter 與原生溝通」的不同方式，重點聚焦在：
- Pigeon 與標準 Platform Channels 的對比（型別安全、可讀性、錯誤處理、開發效率）。
- 各種溝通方式的範例與生成碼片段（含 dart:ffi 介紹）；Web-only 方式（JS interop）僅概念提及，不實作。

## 平台支援策略
- **原生實作僅針對 macOS**：實際示範與測試都集中在 macOS，方便維護並降低開發成本。
- 其他平台（Android/iOS/Web/Linux/Windows）只展示概念或程式碼片段；遇到實機展示的區塊請顯示「不支援」等提示。

## 開發提示
- 若要體驗互動示範，請以 macOS 為目標平台執行。
- 原生/平台通訊範例與筆記位於 `lib/` 相關頁面與 `notes/`。

## 專案目標
- 協助團隊/觀眾理解 Pigeon 相對於標準 Platform Channels 的優勢與使用情境。
- 透過可運行的 macOS 範例與投影片，展示程式碼可讀性、錯誤處理與開發效率差異。
- 簡報受眾以 Android 開發者為主：展示程式碼將以 Android (Java/Kotlin) 片段為例，但實作與示範實際跑在 macOS。

## Pigeon 生成指令
- 以 fvm 執行全部介面檔的生成：
  - `for f in pigeons/*.dart; do fvm dart run pigeon --input "$f"; done`