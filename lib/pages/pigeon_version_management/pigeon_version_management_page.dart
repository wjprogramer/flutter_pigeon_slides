import 'package:flutter/material.dart';

class PigeonVersionManagementPage extends StatelessWidget {
  const PigeonVersionManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pigeon 版本管理與升級策略'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'CI 中的 Pigeon Diff 檢查',
            children: [
              const Text(
                '當 Pigeon 升級造成大量檔案都有 diff 時的處理策略：',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _BulletPoint('情境：', [
                '已經有 CI 設定，每次 merge 到 master/main 之前都會跑 pigeon 確認是否有 diff',
                'Pigeon 升級後，產生大量檔案都有 diff',
                '要上版但沒時間處理所有 diff',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('暫時解決方案：', [
                '在 pipeline 中暫時關閉 pigeon 的 diff 檢查',
                '允許暫時跳過檢查，讓版本可以上線',
                '⚠️ 注意：這只是權宜之計，後續仍需處理',
              ]),
              const SizedBox(height: 12),
              _InfoCard(
                content: '建議在 CI 配置中提供一個開關，可以暫時關閉 pigeon diff 檢查，但需要明確標記原因和預計處理時間。',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '類別風暴（Class Explosion）問題',
            children: [
              const Text(
                '為什麼不應該把所有功能塞到一個 Pigeon 檔案？',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _BulletPoint('問題 1：類別數量上限', [
                '從 codec 的實作層面來說，類別是有數量上限的',
                'Pigeon 最多只能產生 128 個 class（Byte 範圍限制）',
                '如果所有功能都在一個檔案，很容易達到上限',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('問題 2：架構設計問題', [
                '根本不該有一個 Pigeon 檔案塞進所有功能的情況發生',
                '應該按照不同類別功能，拆分成不同的 Pigeon 檔案',
                '這樣可以：',
                '  • 一個一個 Pigeon 檔案去處理升級問題',
                '  • 降低單一檔案複雜度',
                '  • 提高可維護性',
              ]),
              const SizedBox(height: 12),
              _WarningCard(
                content: '把所有功能集中在一個 Pigeon 檔案中，不僅會造成類別風暴，還會讓升級變得困難。應該按照功能模組拆分。',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'Pigeon 檔案拆分策略',
            children: [
              const Text(
                '如何正確地組織 Pigeon 檔案：',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _BulletPoint('拆分原則：', [
                '按功能模組拆分：例如 DeviceApi、StorageApi、NetworkApi 等',
                '按業務領域拆分：例如 User、Order、Payment 等',
                '每個 Pigeon 檔案應該有明確的職責範圍',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('拆分的好處：', [
                '升級時可以一個一個檔案處理，降低風險',
                '減少單一檔案達到類別上限的風險',
                '提高程式碼的可讀性和可維護性',
                '團隊成員可以並行開發不同模組',
              ]),
              const SizedBox(height: 12),
              _ExampleCard(
                title: '範例：',
                content: '''// ❌ 不好的做法：所有功能在一個檔案
// pigeons/all_apis.dart
@ConfigurePigeon(...)
class DeviceApi { ... }
class StorageApi { ... }
class NetworkApi { ... }
// ... 100+ 個 class

// ✅ 好的做法：按功能拆分
// pigeons/device_api.dart
@ConfigurePigeon(...)
class DeviceApi { ... }

// pigeons/storage_api.dart
@ConfigurePigeon(...)
class StorageApi { ... }

// pigeons/network_api.dart
@ConfigurePigeon(...)
class NetworkApi { ... }''',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'Pigeon 定版策略',
            children: [
              const Text(
                '如何減少升級造成的 diff：',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _BulletPoint('定版的好處：', [
                '鎖定特定版本的 Pigeon',
                '減少因為版本升級造成的意外 diff',
                '提供更穩定的開發環境',
                '可以控制升級時機',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('定版策略：', [
                '在 pubspec.yaml 中明確指定 Pigeon 版本',
                '定期檢查新版本，評估是否需要升級',
                '升級前先在測試環境驗證',
                '升級時可以一個一個 Pigeon 檔案處理',
              ]),
              const SizedBox(height: 12),
              _ExampleCard(
                title: '範例：',
                content: '''# pubspec.yaml
dev_dependencies:
  pigeon: ^26.1.4  # 明確指定版本，不要用 ^ 或 ~

# 或者更嚴格
dev_dependencies:
  pigeon: 26.1.4  # 完全鎖定版本''',
              ),
              const SizedBox(height: 12),
              _InfoCard(
                content: '定版不代表永遠不升級，而是要有計劃地升級。建議定期（例如每季度）檢查新版本，評估升級的必要性和影響範圍。',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '升級處理流程',
            children: [
              const Text(
                '當需要升級 Pigeon 時的建議流程：',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _NumberedList([
                '評估升級影響：檢查 changelog，了解破壞性變更',
                '在測試分支升級並執行生成',
                '檢查產生的 diff，評估修改範圍',
                '如果 diff 太大，考慮暫時關閉 CI 檢查',
                '按模組逐步處理：一個一個 Pigeon 檔案處理',
                '測試驗證：確保功能正常',
                '重新啟用 CI 檢查',
                '更新文件：記錄升級版本和注意事項',
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint(this.title, this.items);

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        if (title.isNotEmpty) const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
      ],
    );
  }
}

class _NumberedList extends StatelessWidget {
  const _NumberedList(this.items);

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final item = entry.value;
        return Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$index. ', style: const TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(item)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Expanded(child: Text(content)),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Expanded(child: Text(content)),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SelectableText(
            content,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

