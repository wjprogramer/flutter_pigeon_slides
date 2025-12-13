import 'package:flutter/material.dart';

class CompileTimeSafetyPage extends StatelessWidget {
  const CompileTimeSafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編譯期檢查'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'AI 開發時代的編譯期檢查',
            children: [
              const Text(
                '隨著 AI Agent 的發展，越來越多人使用 AI 來協助開發軟體。在這個背景下，編譯期檢查變得更加重要。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            '傳統 MethodChannel 的問題',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '如果 AI 使用傳統的手寫 MethodChannel，假設 AI 寫錯了：',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• 在 compile 階段無法發現錯誤\n'
                        '• 錯誤可能要到 runtime 才會被發現\n'
                        '• 需要實際執行才能驗證正確性\n'
                        '• 除錯成本高，需要追蹤字串、型別轉換等問題',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'Pigeon 的優勢',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '使用 Pigeon 時，即使 AI 實作有誤：',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• 編譯期就能發現型別錯誤\n'
                        '• 介面不匹配會在編譯時報錯\n'
                        '• 減少一層風險，降低除錯成本\n'
                        '• IDE 可以提供即時錯誤提示',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '適用於所有開發場景',
            children: [
              const Text(
                '雖然我們以 AI 開發為例，但編譯期檢查的優勢同樣適用於傳統開發方式。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _BulletPoint(
                '人工開發',
                [
                  '開發者可能打錯字（typo）',
                  '可能忘記更新某個地方的程式碼',
                  '可能傳遞錯誤的型別',
                  '編譯期檢查可以立即發現這些問題',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '團隊協作',
                [
                  '不同開發者可能有不同的實作風格',
                  '介面變更時可能遺漏某些地方',
                  '編譯期檢查確保介面一致性',
                  '減少 code review 時發現的問題',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '重構與維護',
                [
                  '重構時需要修改多處程式碼',
                  '容易遺漏某些地方未更新',
                  '編譯期檢查確保所有地方都已更新',
                  '減少重構帶來的風險',
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '實際案例',
            children: [
              _ExampleCard(
                title: '案例 1：型別錯誤',
                problem: 'AI 或開發者寫了：\n'
                    '```dart\n'
                    'channel.invokeMethod("increment", {"delta": "1"});\n'
                    '```\n'
                    'delta 應該是 int，但傳了 String',
                solution: '使用 Pigeon：\n'
                    '```dart\n'
                    'api.increment(1); // 編譯期就會檢查型別\n'
                    '```',
              ),
              const SizedBox(height: 16),
              _ExampleCard(
                title: '案例 2：方法名稱錯誤',
                problem: 'AI 或開發者寫了：\n'
                    '```dart\n'
                    'channel.invokeMethod("incremnt", ...); // typo\n'
                    '```\n'
                    '方法名稱打錯，但編譯期無法發現',
                solution: '使用 Pigeon：\n'
                    '```dart\n'
                    'api.increment(...); // 編譯期就會檢查方法是否存在\n'
                    '```',
              ),
              const SizedBox(height: 16),
              _ExampleCard(
                title: '案例 3：欄位遺漏',
                problem: 'AI 或開發者忘記傳遞某個必要欄位：\n'
                    '```dart\n'
                    'channel.invokeMethod("update", {"name": "test"});\n'
                    '// 忘記傳遞 "id" 欄位\n'
                    '```',
                solution: '使用 Pigeon：\n'
                    '```dart\n'
                    'api.update(UpdateRequest(id: 1, name: "test"));\n'
                    '// 編譯期就會檢查所有必要欄位\n'
                    '```',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.children,
  });

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
  const _BulletPoint(this.title, this.points);

  final String title;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.problem,
    required this.solution,
  });

  final String title;
  final String problem;
  final String solution;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        '問題',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    problem,
                    style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        '解決方案',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    solution,
                    style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

