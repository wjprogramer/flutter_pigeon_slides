import 'package:flutter/material.dart';

class PigeonVsMethodChannelPage extends StatelessWidget {
  const PigeonVsMethodChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pigeon vs MethodChannel 根本異同'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '底層實作：本質相同',
            children: [
              const Text(
                '在底層，Pigeon 和 MethodChannel 都使用相同的機制：',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _BulletPoint('', [
                '都使用 BinaryMessenger 進行訊息傳遞',
                '都使用 StandardMessageCodec 進行編解碼',
                '都走同一套 platform messaging 機制',
                '底層實作本質上沒有差異',
              ]),
              const SizedBox(height: 12),
              _CodeExample(
                title: 'MethodChannel 實作：',
                code: '''// MethodChannel 底層
_channel.invokeMethod('getDeviceInfo')
  ↓
BinaryMessenger.send()
  ↓
StandardMessageCodec 編解碼''',
              ),
              const SizedBox(height: 12),
              _CodeExample(
                title: 'Pigeon 實作：',
                code: '''// Pigeon 底層
pigeonApi.getDeviceInfo()
  ↓
BasicMessageChannel.send()
  ↓
BinaryMessenger.send()
  ↓
StandardMessageCodec 編解碼''',
              ),
              const SizedBox(height: 12),
              _InfoCard(
                content: '結論：兩者在底層傳輸機制上完全相同，都使用 binaryMessenger.send 和 StandardMessageCodec。',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '差異在於抽象層級',
            children: [
              const Text(
                '雖然底層相同，但差異在於抽象層級和開發體驗：',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _ComparisonTable(),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '核心差異總結',
            children: [
              _BulletPoint('型別安全：', [
                'Pigeon：編譯期檢查，型別錯誤在編譯時就會發現',
                'MethodChannel：執行期檢查，型別錯誤要到執行時才知道',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('錯誤處理：', [
                'Pigeon：統一錯誤格式（code/message/details），包含 StackTrace',
                'MethodChannel：需要手動處理錯誤格式，容易不一致',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('代碼生成：', [
                'Pigeon：自動生成樣板程式碼，減少手寫錯誤',
                'MethodChannel：完全手寫，容易有 typo 和漏改',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('維護性：', [
                'Pigeon：有明確的介面契約，變更時自動同步',
                'MethodChannel：需要手動同步兩端，容易漏改',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('開發體驗：', [
                'Pigeon：IDE 自動完成、型別提示、重構支援',
                'MethodChannel：字串常數，沒有 IDE 支援',
              ]),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '選擇建議',
            children: [
              _BulletPoint('適合使用 Pigeon：', [
                '介面會持續演進',
                '需要型別安全',
                '多人協作專案',
                '需要統一錯誤處理',
                '長期維護的專案',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('適合使用 MethodChannel：', [
                '一次性、簡單的需求',
                '確定不會演進的功能',
                '團隊已經非常熟悉 MethodChannel',
                'PoC 或快速原型',
              ]),
              const SizedBox(height: 12),
              _WarningCard(
                content: '記住：底層實作相同，選擇的考量點在於開發體驗、維護性和型別安全，而不是效能差異。',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            _TableCell('項目', isHeader: true),
            _TableCell('Pigeon', isHeader: true),
            _TableCell('MethodChannel', isHeader: true),
          ],
        ),
        const TableRow(
          children: [
            _TableCell('底層機制'),
            _TableCell('BinaryMessenger\nStandardMessageCodec'),
            _TableCell('BinaryMessenger\nStandardMessageCodec'),
          ],
        ),
        const TableRow(
          children: [
            _TableCell('型別檢查'),
            _TableCell('編譯期'),
            _TableCell('執行期'),
          ],
        ),
        const TableRow(
          children: [
            _TableCell('錯誤處理'),
            _TableCell('統一格式\n自動封裝'),
            _TableCell('手動處理\n容易不一致'),
          ],
        ),
        const TableRow(
          children: [
            _TableCell('代碼生成'),
            _TableCell('自動生成'),
            _TableCell('完全手寫'),
          ],
        ),
        const TableRow(
          children: [
            _TableCell('介面契約'),
            _TableCell('明確定義'),
            _TableCell('隱式約定'),
          ],
        ),
        const TableRow(
          children: [
            _TableCell('IDE 支援'),
            _TableCell('完整支援'),
            _TableCell('有限支援'),
          ],
        ),
        const TableRow(
          children: [
            _TableCell('維護成本'),
            _TableCell('低（自動同步）'),
            _TableCell('高（手動同步）'),
          ],
        ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell(this.text, {this.isHeader = false});

  final String text;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 14 : 13,
        ),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

class _CodeExample extends StatelessWidget {
  const _CodeExample({required this.title, required this.code});

  final String title;
  final String code;

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
            code,
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


