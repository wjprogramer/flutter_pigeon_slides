import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/pages/api_count_comparison/api_count_data.dart';
import 'package:flutter_pigeon_slides/widgets/common/code.dart';

class ApiCountComparisonPage extends StatefulWidget {
  const ApiCountComparisonPage({super.key});

  @override
  State<ApiCountComparisonPage> createState() => _ApiCountComparisonPageState();
}

class _ApiCountComparisonPageState extends State<ApiCountComparisonPage> {
  List<ApiCountData> _packages = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final packages = await loadOtherPackagesApiCount();
      setState(() {
        _packages = packages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pigeon 的 API 數量很少'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pigeon 的 API 數量很少'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('載入數據失敗: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('重試'),
              ),
            ],
          ),
        ),
      );
    }

    final statistics = ApiCountStatistics.calculate(_packages);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pigeon 的 API 數量很少'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '核心結論',
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
                            'Pigeon 的 API 數量極少',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _StatRow(
                        label: 'Pigeon 完整 API 數量',
                        value: '$pigeonApiCount',
                        highlight: true,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '（包含所有 Classes、Enums、Constants）',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 8),
                      _StatRow(
                        label: '其他套件平均 API 數量',
                        value: '${statistics.averageApiCount.toStringAsFixed(1)}',
                      ),
                      const SizedBox(height: 8),
                      _StatRow(
                        label: 'Pigeon 排名（由少到多）',
                        value: '第 ${statistics.pigeonRank} 名',
                        highlight: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '數據收集流程',
            children: [
              const Text(
                '為了客觀呈現 Pigeon 的 API 數量，我們進行了以下數據收集：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _StepCard(
                step: 1,
                title: '獲取套件列表',
                description: '從 pub.dev 獲取排名前 100 的套件（根據 popularity 排序）',
                code: '''# 使用 pub.dev API
url = "https://pub.dev/api/packages"
params = {
    "page": 1,
    "pageSize": 100,
    "sort": "popularity",
}
response = requests.get(url, params=params)''',
              ),
              const SizedBox(height: 16),
              _StepCard(
                step: 2,
                title: '解析 API 文件',
                description: '訪問每個套件的 API 文件頁面，統計 API 數量',
                code: '''# 訪問套件的 API 文件
doc_url = f"https://pub.dev/documentation/{package_name}/latest/"

# 統計 API 數量（類別、函數、方法等）
api_patterns = [
    'class ',
    'function ',
    'method ',
    'typedef ',
    'enum ',
]''',
              ),
              const SizedBox(height: 16),
              _StepCard(
                step: 3,
                title: '輸出數據',
                description: '將收集的數據轉換為 JSON 或 Dart 數據結構',
                code: '''# 輸出為 JSON
[
  {
    "package_name": "http",
    "api_count": 15,
    "description": "HTTP 客戶端套件",
    "pub_dev_url": "https://pub.dev/packages/http"
  },
  ...
]''',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '統計數據',
            children: [
              _StatisticsCard(statistics: statistics),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '套件對比',
            children: [
              Text(
                '以下收集了 ${_packages.length} 個套件的 API 數量對比：',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              ..._packages.map(
                (package) => _PackageComparisonCard(
                  package: package,
                  pigeonCount: pigeonApiCount,
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '為什麼 API 數量少很重要？',
            children: [
              _BulletPoint('學習成本低', [
                'API 數量少意味著需要學習的內容少',
                '開發者可以快速上手',
                '減少記憶負擔',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('維護成本低', [
                'API 少意味著需要維護的介面少',
                '減少破壞性變更的可能性',
                '更容易保持向後相容',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('專注核心功能', [
                'Pigeon 專注於型別安全的通訊',
                '不需要過多的輔助 API',
                '設計簡潔明確',
              ]),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '數據收集腳本',
            children: [
              const Text(
                '完整的數據收集腳本位於：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              PageCodeBlock(
                code: '''scripts/collect_api_count.dart

# 執行方式（在專案根目錄）：
dart run scripts/collect_api_count.dart

# 腳本會：
# 1. 從 pub.dev 獲取排名前 100 的套件
# 2. 解析每個套件的 API 文件
# 3. 統計 API 數量
# 4. 輸出 Dart 代碼（可直接複製）
# 5. 保存到 scripts/api_count_output.dart''',
                // language: 'bash',
                fontSize: 14.0,
              ),
              const SizedBox(height: 12),
              const Text(
                '詳細說明請參考：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              PageCodeBlock(
                code: '''scripts/README_API_COLLECTION.md''',
                // language: 'text',
                fontSize: 14.0,
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

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: highlight ? Colors.green.shade700 : null,
          ),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.step,
    required this.title,
    required this.description,
    required this.code,
  });

  final int step;
  final String title;
  final String description;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$step',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            PageCodeBlock(
              code: code,
              language: 'python',
              fontSize: 14.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({required this.statistics});

  final ApiCountStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '統計資訊',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _StatRow(
              label: '總套件數',
              value: '${statistics.totalPackages}',
            ),
            const SizedBox(height: 8),
            _StatRow(
              label: '平均 API 數量',
              value: '${statistics.averageApiCount.toStringAsFixed(1)}',
            ),
            const SizedBox(height: 8),
            _StatRow(
              label: '中位數',
              value: '${statistics.medianApiCount.toStringAsFixed(1)}',
            ),
            const SizedBox(height: 8),
            _StatRow(
              label: '最小 API 數量',
              value: '${statistics.minApiCount}',
            ),
            const SizedBox(height: 8),
            _StatRow(
              label: '最大 API 數量',
              value: '${statistics.maxApiCount}',
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageComparisonCard extends StatelessWidget {
  const _PackageComparisonCard({
    required this.package,
    required this.pigeonCount,
  });

  final ApiCountData package;
  final int pigeonCount;

  @override
  Widget build(BuildContext context) {
    final isLessThanPigeon = package.apiCount < pigeonCount;
    final isEqualPigeon = package.apiCount == pigeonCount;

    return Card(
      color: isLessThanPigeon
          ? Colors.green.shade50
          : isEqualPigeon
              ? Colors.blue.shade50
              : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.packageName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (package.description.isNotEmpty)
                    Text(
                      package.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${package.apiCount}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isLessThanPigeon
                    ? Colors.green.shade700
                    : isEqualPigeon
                        ? Colors.blue.shade700
                        : null,
              ),
            ),
            const SizedBox(width: 8),
            if (package.apiCount > pigeonCount)
              Icon(
                Icons.arrow_upward,
                color: Colors.red.shade700,
                size: 20,
              )
            else if (package.apiCount < pigeonCount)
              Icon(
                Icons.arrow_downward,
                color: Colors.green.shade700,
                size: 20,
              )
            else
              Icon(
                Icons.remove,
                color: Colors.blue.shade700,
                size: 20,
              ),
            const SizedBox(width: 8),
            Text(
              'Pigeon: $pigeonCount',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
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

