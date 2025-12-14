# API 數量收集流程說明

## 目標

收集 pub.dev 上排名前 100 的套件的 API 數量，並與 Pigeon 進行對比，以客觀數據證明「Pigeon 的 API 數量很少」。

## 流程

### 1. 執行收集腳本

```bash
# 在專案根目錄執行
dart run scripts/collect_api_count.dart
```

### 2. 腳本執行流程

1. **獲取套件列表**
   - 從 pub.dev API 獲取排名前 100 的套件
   - 使用 `popularity` 排序

2. **解析 API 文件**
   - 訪問每個套件的 API 文件頁面
   - 統計 API 數量（類別、函數、方法等）

3. **輸出結果**
   - 在終端顯示 Dart 代碼（可直接複製）
   - 保存到 `scripts/api_count_output.dart`
   - 同時保存 JSON 格式到 `scripts/api_count_output.json`

### 3. 複製數據到專案

腳本執行完成後：

1. **查看輸出**
   - 終端會顯示完整的 Dart 代碼
   - 可以直接複製

2. **或從文件複製**
   - 打開 `scripts/api_count_output.dart`
   - 複製內容

3. **更新專案文件**
   - 打開 `lib/pages/api_count_comparison/api_count_data.dart`
   - 找到 `otherPackagesApiCount` 常數
   - 替換為收集到的數據

### 4. 數據格式

生成的 Dart 代碼格式：

```dart
const otherPackagesApiCount = <ApiCountData>[
  ApiCountData(
    packageName: 'http',
    apiCount: 15,
    description: 'HTTP 客戶端套件',
  ),
  ...
];
```

## 注意事項

1. **API 限制**
   - pub.dev API 可能有請求頻率限制
   - 腳本已加入延遲以避免過於頻繁的請求

2. **統計方法**
   - 目前的統計方法較為簡化
   - 可能需要根據實際情況調整統計邏輯

3. **數據驗證**
   - 收集完成後應手動驗證部分數據
   - 確保統計結果的準確性

## 改進方向

1. **更精確的 API 統計**
   - 解析 Dart 源碼文件
   - 使用 dartdoc 的結構化數據

2. **分類統計**
   - 按套件類別（網路、狀態管理、儲存等）分類
   - 提供更詳細的對比分析

3. **自動化流程**
   - 定期更新數據
   - CI/CD 自動執行收集腳本

