import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/pages/api_analysis/api_analysis_page.dart';
import 'package:flutter_pigeon_slides/pages/api_doc/api_doc_page.dart';

class LearningCurvePage extends StatelessWidget {
  const LearningCurvePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('學習曲線'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '官方文件與 API 參考',
            children: [
              const Text(
                'Pigeon 的學習曲線相對平緩，其中一個重要原因是官方提供了完整的 API 文件。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ApiAnalysisPage(),
                    ),
                  );
                },
                child: Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.insights, color: Colors.green.shade700),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                '關鍵洞察：API 數量極少',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.open_in_new,
                              color: Colors.green.shade700,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '查看 Pigeon 的官方 API 文件，你會發現：',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• API 數量非常少，核心概念簡單\n'
                          '• 很多內容只是不同平台的 Options（配置選項）\n'
                          '• 實際上需要學習的 API 非常少\n'
                          '• 大部分時間都在使用相同的幾個 API',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '這意味著學習成本很低：你不需要記住大量的 API，只需要掌握幾個核心概念就能開始使用。',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '為什麼官方文件對學習曲線很重要？',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 快速查找：當需要了解某個 API 的用法時，可以直接查閱官方文件\n'
                '• 減少試錯：明確的 API 定義減少猜測和實驗的時間\n'
                '• 型別安全：Pigeon 生成的程式碼有完整的型別定義，IDE 可以提供自動完成\n'
                '• 範例參考：官方文件通常包含使用範例，加速理解\n'
                '• API 簡單：數量少、概念清晰，容易掌握',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(Icons.description, color: Colors.blue),
                  title: const Text('查看 Pigeon API 文件'),
                  subtitle: const Text('了解完整的 API 介面與使用方式'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ApiDocPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '多平台開發的學習成本',
            children: [
              const Text(
                '在討論「學習曲線」時，除了 Pigeon 本身的學習成本，還需要考慮原生平台的學習難度。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                '現實情況',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '很少有開發者能對所有平台都很熟悉。假設專案需要支援多平台：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '如果對 iOS Swift 不熟悉',
                [
                  '需要查詢 Swift 與 Dart 型別的對應關係',
                  '需要了解 Swift 的錯誤處理方式',
                  '需要學習 Swift 的語法與慣例',
                  '需要處理大量的樣板程式碼',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '如果對 Android Kotlin 不熟悉',
                [
                  '需要查詢 Kotlin 與 Dart 型別的對應關係',
                  '需要了解 Kotlin 的錯誤處理方式',
                  '需要學習 Kotlin 的語法與慣例',
                  '需要處理大量的樣板程式碼',
                ],
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.orange.shade700),
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
                        '使用 Pigeon 時，你只需要：\n'
                        '1. 定義 Dart 介面（你已經熟悉的語言）\n'
                        '2. 實作原生端的邏輯（可以參考生成的程式碼）\n'
                        '3. 型別對應由 Pigeon 自動處理，減少查詢時間\n'
                        '4. 錯誤處理格式統一，減少學習成本',
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
            title: '其他學習成本考量',
            children: [
              _BulletPoint(
                '介面定義的學習',
                [
                  'Pigeon 的介面定義語法簡單直觀',
                  '類似 Dart 的 class 定義，容易理解',
                  '註解和文件可以幫助理解',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '生成流程的學習',
                [
                  '需要了解如何執行 Pigeon 生成指令',
                  '可以透過 File Watchers 自動化，降低學習成本',
                  'CI/CD 整合可以進一步簡化流程',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '除錯與問題排查',
                [
                  'Pigeon 生成的程式碼有統一的錯誤格式',
                  'Stack trace 包含 Dart 和原生端的資訊',
                  '型別安全減少 runtime 錯誤',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '團隊協作',
                [
                  '介面定義即契約，減少溝通成本',
                  '新成員可以快速理解 API 結構',
                  '統一的程式碼風格，降低閱讀門檻',
                ],
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

