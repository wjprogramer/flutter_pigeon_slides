import 'package:flutter/material.dart';

class DevelopmentSpeedPage extends StatelessWidget {
  const DevelopmentSpeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('開發速度比較'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '開發速度的關鍵因素',
            children: [
              const Text(
                '開發速度不僅僅是「寫程式碼的速度」，還包括：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _FactorCard(
                title: '初始開發時間',
                icon: Icons.play_arrow,
                color: Colors.blue,
                items: [
                  '定義介面和實作所需的時間',
                  '樣板程式碼的撰寫量',
                  '第一次實作的學習曲線',
                ],
              ),
              const SizedBox(height: 12),
              _FactorCard(
                title: '除錯時間',
                icon: Icons.bug_report,
                color: Colors.red,
                items: [
                  '型別錯誤的發現和修復',
                  '字串 typo 導致的運行時錯誤',
                  '參數不匹配的問題',
                  '錯誤處理不一致造成的問題',
                ],
              ),
              const SizedBox(height: 12),
              _FactorCard(
                title: '維護與迭代時間',
                icon: Icons.update,
                color: Colors.orange,
                items: [
                  '修改介面時的同步成本',
                  '新增欄位或方法的工作量',
                  '重構和優化的難度',
                  '團隊協作時的溝通成本',
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '初始開發速度',
            children: [
              _ComparisonCard(
                title: '簡單 API（1-2 個方法）',
                pigeon: [
                  '需要創建介面定義文件',
                  '執行代碼生成命令',
                  '實作原生端介面',
                  '總時間：約 10-15 分鐘',
                ],
                traditional: [
                  '直接撰寫 Method Channel 調用',
                  '實作原生端 handler',
                  '總時間：約 5-8 分鐘',
                ],
                winner: '傳統 Method Channel 稍快',
                note: '對於極簡單的一次性 API，傳統方式確實更快',
              ),
              const SizedBox(height: 16),
              _ComparisonCard(
                title: '中等複雜度 API（3-5 個方法，有資料類別）',
                pigeon: [
                  '定義資料類別和介面',
                  '執行代碼生成',
                  '實作原生端介面',
                  '總時間：約 20-30 分鐘',
                ],
                traditional: [
                  '手寫資料類別序列化/反序列化',
                  '撰寫 Method Channel 調用',
                  '實作原生端 handler 和資料轉換',
                  '處理錯誤封裝',
                  '總時間：約 30-45 分鐘',
                ],
                winner: 'Pigeon 更快',
                note: 'Pigeon 自動生成序列化代碼，節省大量時間',
              ),
              const SizedBox(height: 16),
              _ComparisonCard(
                title: '複雜 API（多個方法、巢狀物件、Enum）',
                pigeon: [
                  '定義完整的資料結構',
                  '執行代碼生成',
                  '實作原生端介面',
                  '總時間：約 30-40 分鐘',
                ],
                traditional: [
                  '手寫複雜的序列化邏輯',
                  '處理 Enum 轉換',
                  '撰寫多個 Method Channel 調用',
                  '實作原生端複雜的資料轉換',
                  '處理各種邊界情況',
                  '總時間：約 60-90 分鐘',
                ],
                winner: 'Pigeon 明顯更快',
                note: '複雜度越高，Pigeon 的優勢越明顯',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '除錯時間比較',
            children: [
              _DebugTimeCard(
                issue: '型別錯誤',
                pigeon: '編譯期發現，立即修正（1-2 分鐘）',
                traditional: '運行時才發現，需要測試和追蹤（10-30 分鐘）',
                advantage: 'Pigeon 節省 90% 時間',
              ),
              const SizedBox(height: 12),
              _DebugTimeCard(
                issue: '字串 typo（method name、channel name）',
                pigeon: '編譯期檢查，不會發生',
                traditional: '運行時 MissingPluginException，需要追蹤和修復（15-45 分鐘）',
                advantage: 'Pigeon 完全避免此問題',
              ),
              const SizedBox(height: 12),
              _DebugTimeCard(
                issue: '參數不匹配',
                pigeon: '編譯期檢查，型別不匹配立即發現（1-2 分鐘）',
                traditional: '運行時錯誤或資料錯誤，需要測試和除錯（20-60 分鐘）',
                advantage: 'Pigeon 節省 95% 時間',
              ),
              const SizedBox(height: 12),
              _DebugTimeCard(
                issue: '錯誤處理不一致',
                pigeon: '統一的錯誤封裝，自動處理（0 分鐘）',
                traditional: '需要手動處理各種錯誤情況，容易遺漏（30-60 分鐘）',
                advantage: 'Pigeon 完全避免此問題',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '維護與迭代速度',
            children: [
              _MaintenanceCard(
                scenario: '新增一個欄位到資料類別',
                pigeon: [
                  '修改介面定義（1 行）',
                  '執行代碼生成',
                  '更新原生端實作',
                  '總時間：約 5-10 分鐘',
                ],
                traditional: [
                  '修改 Dart 資料類別',
                  '修改序列化/反序列化邏輯',
                  '修改原生端資料轉換',
                  '測試所有使用該資料的地方',
                  '總時間：約 20-40 分鐘',
                ],
                advantage: 'Pigeon 快 2-4 倍',
              ),
              const SizedBox(height: 16),
              _MaintenanceCard(
                scenario: '新增一個方法',
                pigeon: [
                  '在介面定義中新增方法（1 行）',
                  '執行代碼生成',
                  '實作原生端方法',
                  '總時間：約 5-8 分鐘',
                ],
                traditional: [
                  '在 Dart 端新增 Method Channel 調用',
                  '定義 method name 常數',
                  '實作原生端 handler',
                  '處理錯誤和參數驗證',
                  '總時間：約 15-25 分鐘',
                ],
                advantage: 'Pigeon 快 2-3 倍',
              ),
              const SizedBox(height: 16),
              _MaintenanceCard(
                scenario: '重構介面（重新命名、調整結構）',
                pigeon: [
                  '修改介面定義',
                  '執行代碼生成',
                  '編譯器會指出所有需要更新的地方',
                  '總時間：約 10-20 分鐘',
                ],
                traditional: [
                  '手動搜尋所有使用的地方',
                  '逐一修改字串和方法名',
                  '容易遺漏，需要大量測試',
                  '總時間：約 40-80 分鐘',
                ],
                advantage: 'Pigeon 快 3-4 倍，且更安全',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '實際案例對比',
            children: [
              _CaseStudyCard(
                title: '案例 1：簡單的計數器 API',
                description: '只有 get、increment、reset 三個方法',
                pigeon: '初始開發：15 分鐘，後續維護：每次變更 5-8 分鐘',
                traditional: '初始開發：10 分鐘，後續維護：每次變更 15-20 分鐘',
                conclusion: '簡單 API 初始開發傳統方式稍快，但維護時 Pigeon 更快',
              ),
              const SizedBox(height: 16),
              _CaseStudyCard(
                title: '案例 2：設備資訊 API',
                description: '包含多個巢狀資料結構和 Enum',
                pigeon: '初始開發：30 分鐘，除錯：5 分鐘，維護：每次變更 8-12 分鐘',
                traditional: '初始開發：60 分鐘，除錯：45 分鐘，維護：每次變更 30-50 分鐘',
                conclusion: '複雜 API 中，Pigeon 在所有階段都明顯更快',
              ),
              const SizedBox(height: 16),
              _CaseStudyCard(
                title: '案例 3：多人協作開發',
                description: '團隊成員需要理解和使用 API',
                pigeon: '介面定義清晰，型別安全，新人上手快，協作順暢',
                traditional: '需要閱讀大量樣板代碼，容易誤用，需要更多溝通',
                conclusion: 'Pigeon 顯著降低團隊協作成本',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '關鍵洞察',
            children: [
              _InsightCard(
                icon: Icons.trending_up,
                title: '複雜度越高，Pigeon 優勢越明顯',
                content:
                    '對於簡單的一次性 API，傳統方式可能稍快。但隨著複雜度增加（多方法、巢狀物件、Enum），Pigeon 的優勢呈指數級增長。',
              ),
              const SizedBox(height: 12),
              _InsightCard(
                icon: Icons.bug_report,
                title: '除錯時間是最大的時間節省',
                content:
                    'Pigeon 的編譯期檢查可以避免大部分運行時錯誤，這是最重要的時間節省來源。一個運行時錯誤的除錯時間可能比整個初始開發時間還長。',
              ),
              const SizedBox(height: 12),
              _InsightCard(
                icon: Icons.update,
                title: '維護成本是長期考量',
                content:
                    '初始開發只佔 API 生命週期的一小部分。在維護和迭代階段，Pigeon 的優勢更加明顯，長期來看節省的時間遠超過初始的學習成本。',
              ),
              const SizedBox(height: 12),
              _InsightCard(
                icon: Icons.people,
                title: '團隊協作效率',
                content:
                    'Pigeon 的型別安全和清晰介面定義，讓團隊成員更容易理解和正確使用 API，減少溝通成本和錯誤使用的情況。',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '結論',
            children: [
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
                            '開發速度總結',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _ConclusionItem(
                        title: '簡單 API（1-2 個方法）',
                        content: '傳統方式初始開發稍快，但維護時 Pigeon 更快',
                      ),
                      const SizedBox(height: 12),
                      _ConclusionItem(
                        title: '中等複雜度 API',
                        content: 'Pigeon 在初始開發和維護階段都更快',
                      ),
                      const SizedBox(height: 12),
                      _ConclusionItem(
                        title: '複雜 API',
                        content: 'Pigeon 在所有階段都明顯更快，節省 50-70% 時間',
                      ),
                      const SizedBox(height: 12),
                      _ConclusionItem(
                        title: '除錯時間',
                        content: 'Pigeon 的編譯期檢查可以節省 90% 以上的除錯時間',
                      ),
                      const SizedBox(height: 12),
                      _ConclusionItem(
                        title: '長期維護',
                        content: '隨著時間推移，Pigeon 的優勢會越來越明顯',
                      ),
                    ],
                  ),
                ),
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class _FactorCard extends StatelessWidget {
  const _FactorCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final IconData icon;
  final MaterialColor color;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 16, color: color.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.title,
    required this.pigeon,
    required this.traditional,
    required this.winner,
    this.note,
  });

  final String title;
  final List<String> pigeon;
  final List<String> traditional;
  final String winner;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
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
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _MethodCard(
                    title: 'Pigeon',
                    color: Colors.blue,
                    items: pigeon,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MethodCard(
                    title: '傳統 Method Channel',
                    color: Colors.orange,
                    items: traditional,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      winner,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (note != null) ...[
              const SizedBox(height: 8),
              Text(
                note!,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.title,
    required this.color,
    required this.items,
  });

  final String title;
  final MaterialColor color;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color.shade700,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(color: color.shade700),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DebugTimeCard extends StatelessWidget {
  const _DebugTimeCard({
    required this.issue,
    required this.pigeon,
    required this.traditional,
    required this.advantage,
  });

  final String issue;
  final String pigeon;
  final String traditional;
  final String advantage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              issue,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _TimeCard(
                    title: 'Pigeon',
                    content: pigeon,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimeCard(
                    title: '傳統方式',
                    content: traditional,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                advantage,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  const _TimeCard({
    required this.title,
    required this.content,
    required this.color,
  });

  final String title;
  final String content;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({
    required this.scenario,
    required this.pigeon,
    required this.traditional,
    required this.advantage,
  });

  final String scenario;
  final List<String> pigeon;
  final List<String> traditional;
  final String advantage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scenario,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _MethodCard(
                    title: 'Pigeon',
                    color: Colors.blue,
                    items: pigeon,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MethodCard(
                    title: '傳統方式',
                    color: Colors.orange,
                    items: traditional,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                advantage,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaseStudyCard extends StatelessWidget {
  const _CaseStudyCard({
    required this.title,
    required this.description,
    required this.pigeon,
    required this.traditional,
    required this.conclusion,
  });

  final String title;
  final String description;
  final String pigeon;
  final String traditional;
  final String conclusion;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
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
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _TimeCard(
                    title: 'Pigeon',
                    content: pigeon,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimeCard(
                    title: '傳統方式',
                    content: traditional,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      conclusion,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade700,
                      ),
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

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  final IconData icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.purple.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 14),
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

class _ConclusionItem extends StatelessWidget {
  const _ConclusionItem({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, size: 20, color: Colors.green.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

