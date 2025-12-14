import 'package:flutter/material.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('活躍度、趨勢與公信力'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '📊 基本數據（2025/09/21 紀錄）',
            children: [
              const Text(
                '以下數據同時反映「活躍度」和「公信力」兩個面向：',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              _StatCard(
                icon: Icons.favorite,
                color: Colors.red,
                title: 'Likes',
                value: '1.17k',
                description: '在 flutter.dev publisher 的 88 個套件中排名第 17 名',
              ),
              const SizedBox(height: 12),
              _StatCard(
                icon: Icons.star,
                color: Colors.amber,
                title: 'Pub Points',
                value: '140 / 160',
                description: '評分系統，反映套件品質',
              ),
              const SizedBox(height: 12),
              _StatCard(
                icon: Icons.download,
                color: Colors.blue,
                title: 'Downloads',
                value: '326k',
                description: '在 flutter.dev publisher 的 88 個套件中排名第 57 名',
              ),
              const SizedBox(height: 12),
              _StatCard(
                icon: Icons.update,
                color: Colors.green,
                title: '更新頻率',
                value: '過去一年 35 個更新',
                description: '持續維護與改進',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '📈 下載量分析',
            children: [
              const Text(
                'Downloads 57 名看起來不突出，但需要考慮背景：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.insights, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            '重要洞察',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pigeon 只有在需要與原生平台溝通時才會被使用。'
                        '在「只有原生開發才需要」的場景下，還能贏過很多套件，這說明：',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• 使用率相對較高：在需要原生溝通的專案中，Pigeon 是常見選擇\n'
                        '• 社群認可：開發者願意採用這個工具\n'
                        '• 實用性強：解決了實際開發中的痛點',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '全部套件排名',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '在所有 Flutter 套件中，Pigeon 的下載量排名第 447 名，贏過許多知名套件：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'open_filex',
                  'intl_utils',
                  'syncfusion_flutter_charts',
                  'grpc',
                  'bot_toast',
                  'qr_code_scanner',
                  'oauth2',
                  'window_manager',
                ].map((name) => Chip(
                      label: Text(name),
                      backgroundColor: Colors.grey.shade200,
                    )).toList(),
              ),
              const SizedBox(height: 12),
              const Text(
                '全部套件中超過 100K 下載量的有 891 個，Pigeon 位列其中。',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '⭐ Pub Points 分析',
            children: [
              const Text(
                '140 / 160 分，扣分項目：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '缺少 WASM 支援',
                ['但 Pigeon 不需要 WASM，因為它是建置期工具'],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '靜態分析問題',
                ['7 個 issues，但網頁上只顯示 2 個', '都是在註解內的輕微問題'],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '依賴套件版本',
                ['有 10 個套件沒跟上最新版', '但只有 analyzer 版本號差了一個（x 版本號）', '其他都是次要版本差異'],
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
                            '整體評價',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '140 分是一個很好的分數，表示：\n'
                        '• 套件品質良好\n'
                        '• 維護積極\n'
                        '• 符合 Flutter 最佳實踐\n'
                        '• 扣分項目都是非關鍵性的',
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
            title: '🔄 活躍度分析',
            children: [
              const Text(
                '活躍度反映套件的維護頻率和社群參與度。過去一年有 35 個更新，這表示：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '積極維護',
                ['官方持續改進和修復問題', '回應社群需求'],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '穩定性考量',
                ['這麼多更新會不會導致不穩定？', '會不會升級困難？'],
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
                            '高活躍度的正面意義',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '1. 大部分更新是向後相容的\n'
                        '2. 主要版本更新會明確標示\n'
                        '3. 可以鎖定版本使用（如 26.1.4）\n'
                        '4. 更新通常帶來改進而非破壞性變更\n'
                        '5. 官方維護意味著長期支援',
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
            title: '🏛️ 公信力分析',
            children: [
              const Text(
                '公信力反映套件的可信度和社群信任度，主要指標包括：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            '官方維護',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pigeon 目前由 Flutter 官方團隊維護，這意味著：',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• 目前官方維護：現階段由官方團隊負責，品質有保障\n'
                        '• 與 Flutter SDK 同步：版本更新與 Flutter 保持一致\n'
                        '• 品質保證：經過官方審查和測試\n'
                        '• 社群信任：開發者更願意採用官方工具\n'
                        '• 即使未來轉移：若轉為社群維護，通常會有明確的過渡期和社群接手（如 package_info → package_info_plus）',
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
                          Icon(Icons.thumb_up, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            '社群認可',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '下載量、喜歡數、Pub Points 等數據反映社群對套件的認可：',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• 高下載量：326k 下載，表示大量專案採用\n'
                        '• 高喜歡數：1.17k likes，在官方套件中排名前 20%\n'
                        '• 高評分：140/160 Pub Points，品質獲得認可\n'
                        '• 持續使用：下載量持續增長，表示實用性強',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
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
                          Icon(Icons.security, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            '穩定性與可靠性',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '公信力也體現在套件的穩定性和可靠性：',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• 版本穩定：可以鎖定版本使用，避免意外變更\n'
                        '• 向後相容：大部分更新都是向後相容的\n'
                        '• 問題修復：積極修復 bug 和問題\n'
                        '• 文檔完整：官方文檔清晰，社群資源豐富',
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
            title: '📊 與其他套件對比',
            children: [
              const Text(
                '在 flutter.dev publisher 的 88 個套件中：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              DataTable(
                columns: const [
                  DataColumn(label: Text('指標')),
                  DataColumn(label: Text('排名')),
                  DataColumn(label: Text('說明')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Likes')),
                    DataCell(Text('17')),
                    DataCell(Text('前 20%，表現優秀')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Downloads')),
                    DataCell(Text('57')),
                    DataCell(Text('考慮使用場景，表現良好')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Pub Points')),
                    DataCell(Text('140/160')),
                    DataCell(Text('品質良好')),
                  ]),
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
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

