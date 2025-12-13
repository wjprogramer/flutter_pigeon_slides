import 'package:flutter/material.dart';

class MaintainabilityPage extends StatelessWidget {
  const MaintainabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('可維護性'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '什麼是可維護性？',
            children: [
              const Text(
                '可維護性指的是程式碼在長期演進過程中，能夠：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              _BulletPoint('', [
                '容易理解和修改',
                '減少引入錯誤的風險',
                '支援多人協作',
                '適應需求變更',
                '降低長期維護成本',
              ]),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '介面即契約',
            children: [
              const Text(
                'Pigeon 的核心優勢之一是「介面即契約」的設計理念。',
                style: TextStyle(fontSize: 16),
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
                          Icon(Icons.verified, color: Colors.green.shade700),
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
                        '• 單一來源：介面定義檔是唯一的真相來源\n'
                        '• 自動同步：Client 和 Host 端自動保持一致\n'
                        '• 編譯期檢查：介面變更時立即發現不一致\n'
                        '• 明確契約：新成員可以快速理解 API 結構',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
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
                            'Standard Channels 的問題',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• 多處定義：Client 和 Host 各自維護，容易不同步\n'
                        '• 字串約定：channel 名稱、method 名稱容易 typo\n'
                        '• 手動同步：變更時需要手動更新多處程式碼\n'
                        '• 隱性錯誤：不一致的問題要到 runtime 才發現',
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
            title: '型別安全與維護',
            children: [
              const Text(
                '型別安全不僅僅是開發時的便利，更是長期維護的保障。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _BulletPoint(
                '編譯期檢查',
                [
                  '介面變更時，編譯器立即發現不一致',
                  '減少 runtime 錯誤，降低線上問題',
                  'IDE 自動完成，減少人為錯誤',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '避免強制轉型',
                [
                  '不需要使用 `as` 強制轉型',
                  '減少型別相關的 runtime 錯誤',
                  '程式碼更安全、更可讀',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '欄位變更安全',
                [
                  '新增或修改欄位時，編譯期檢查所有使用處',
                  '避免遺漏更新某些地方',
                  '重構更安全',
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '錯誤處理的一致性',
            children: [
              const Text(
                '統一的錯誤處理格式是長期維護的重要保障。',
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
                      const Text(
                        'Pigeon 的錯誤處理',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• 統一格式：所有錯誤都使用相同的封裝格式\n'
                        '• Stack trace：包含 Dart 和原生端的堆疊資訊\n'
                        '• 快速定位：錯誤發生時可以快速找到問題根源\n'
                        '• 一致體驗：所有 API 的錯誤處理方式相同',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Standard Channels 的問題：',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 不同方法可能使用不同的錯誤格式\n'
                '• 需要手動規範錯誤格式，容易不一致\n'
                '• 長期維護時，不同開發者可能用不同格式\n'
                '• 除錯時需要了解每種錯誤格式',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '介面演進與變更',
            children: [
              const Text(
                '隨著需求變更，API 介面也需要演進。Pigeon 讓這個過程更安全。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _BulletPoint(
                '新增欄位',
                [
                  '編譯期檢查所有使用處',
                  '自動生成新的編解碼邏輯',
                  '減少遺漏更新的風險',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '修改欄位',
                [
                  '型別變更時立即發現問題',
                  '自動更新 Client 和 Host 端',
                  '減少手動同步的錯誤',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '新增方法',
                [
                  '介面定義清晰，易於理解',
                  '自動生成樣板程式碼',
                  '減少實作不一致的問題',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '重構',
                [
                  '介面變更時，所有相關程式碼都會被檢查',
                  '減少重構帶來的風險',
                  '更容易進行大規模重構',
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '多人協作',
            children: [
              const Text(
                '在團隊開發中，可維護性尤其重要。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.purple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pigeon 的協作優勢',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• 明確契約：介面定義即契約，減少溝通成本\n'
                        '• 統一風格：所有 API 使用相同的結構和命名\n'
                        '• 易於審查：Code review 時聚焦介面定義\n'
                        '• 快速上手：新成員可以快速理解 API 結構\n'
                        '• 減少衝突：命名規範減少 channel 名稱衝突',
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
            title: '長期維護成本',
            children: [
              const Text(
                '考慮長期維護時，Pigeon 的優勢更加明顯。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _ComparisonTable(
                title: '維護成本對比',
                items: [
                  _ComparisonItem(
                    aspect: '介面變更',
                    pigeon: '修改介面檔，自動同步',
                    standard: '手動更新多處程式碼',
                  ),
                  _ComparisonItem(
                    aspect: '錯誤處理',
                    pigeon: '統一格式，自動生成',
                    standard: '手動維護，容易不一致',
                  ),
                  _ComparisonItem(
                    aspect: '型別安全',
                    pigeon: '編譯期檢查',
                    standard: 'Runtime 才發現錯誤',
                  ),
                  _ComparisonItem(
                    aspect: '程式碼審查',
                    pigeon: '聚焦介面定義',
                    standard: '需要檢查多處實作',
                  ),
                  _ComparisonItem(
                    aspect: '新人上手',
                    pigeon: '查看介面定義即可',
                    standard: '需要理解多處實作',
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '實際案例',
            children: [
              _ExampleCard(
                title: '案例 1：新增欄位',
                scenario: '需要在 DeviceInfo 中新增一個欄位',
                pigeon: '1. 修改介面定義\n'
                    '2. 執行生成指令\n'
                    '3. 實作業務邏輯\n'
                    '4. 編譯期檢查所有使用處',
                standard: '1. 修改 Client 端程式碼\n'
                    '2. 修改 Host 端程式碼\n'
                    '3. 手動更新編解碼邏輯\n'
                    '4. 檢查所有使用處（容易遺漏）',
              ),
              const SizedBox(height: 16),
              _ExampleCard(
                title: '案例 2：錯誤處理',
                scenario: '需要統一錯誤處理格式',
                pigeon: '自動生成統一的錯誤格式，所有 API 一致',
                standard: '需要手動在每個方法中實作，容易不一致',
              ),
              const SizedBox(height: 16),
              _ExampleCard(
                title: '案例 3：團隊協作',
                scenario: '新成員需要了解 API 結構',
                pigeon: '查看介面定義檔即可，清晰明確',
                standard: '需要查看多處實作，理解不同風格的程式碼',
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
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (title.isNotEmpty) const SizedBox(height: 8),
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

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_ComparisonItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('面向')),
              DataColumn(label: Text('Pigeon')),
              DataColumn(label: Text('Standard Channels')),
            ],
            rows: items.map((item) => DataRow(
                  cells: [
                    DataCell(Text(item.aspect)),
                    DataCell(
                      Text(
                        item.pigeon,
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.standard,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                )).toList(),
          ),
        ],
      ),
    );
  }
}

class _ComparisonItem {
  const _ComparisonItem({
    required this.aspect,
    required this.pigeon,
    required this.standard,
  });

  final String aspect;
  final String pigeon;
  final String standard;
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.scenario,
    required this.pigeon,
    required this.standard,
  });

  final String title;
  final String scenario;
  final String pigeon;
  final String standard;

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
            const SizedBox(height: 8),
            Text(
              '場景：$scenario',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
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
                              'Pigeon',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pigeon,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.grey.shade700, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Standard',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          standard,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

