import 'package:flutter/material.dart';

class CiIntegrationPage extends StatelessWidget {
  const CiIntegrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pigeon 與 CI/CD'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '為什麼需要 CI 整合？',
            children: [
              const Text(
                'Pigeon 需要 codegen 流程，CI 整合可以確保：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              _BulletPoint('', [
                '介面變更時自動生成程式碼',
                '檢查介面與產物是否同步',
                '避免漏跑生成指令',
                '確保團隊成員都使用最新產物',
                '減少人為錯誤',
              ]),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'CI 檢查策略',
            children: [
              const Text(
                '有幾種方式可以在 CI 中檢查 Pigeon 產物：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _StrategyCard(
                title: '方法 1：自動生成並檢查 diff',
                description: '在 CI 中執行生成指令，檢查是否有變更',
                steps: [
                  'CI 檢測到 pigeons/ 目錄或介面檔有變更',
                  '自動執行 pigeon 生成指令',
                  '檢查生成的檔案是否有變更（git diff）',
                  '如果有變更但未提交，CI 失敗',
                ],
                example: r'''# .github/workflows/pigeon-check.yml
on:
  pull_request:
    paths:
      - 'pigeons/**'
      - 'lib/pigeons/**'

jobs:
  check-pigeon:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: |
          for f in pigeons/*.dart; do
            dart run pigeon --input "$f"
          done
      - run: |
          if [ -n "$(git status --porcelain)" ]; then
            echo "Pigeon 產物未同步，請執行生成指令"
            git diff
            exit 1
          fi''',
              ),
              const SizedBox(height: 16),
              _StrategyCard(
                title: '方法 2：比對產物 hash',
                description: '計算產物的 hash 值，檢查是否一致',
                steps: [
                  '在 CI 中執行生成指令',
                  '計算生成檔案的 hash 值',
                  '與預期的 hash 值比對',
                  '不一致則 CI 失敗',
                ],
                example: r'''# 計算產物 hash
HASH=$(find lib/pigeons -name "*.g.dart" -exec md5sum {} \; | sort | md5sum)
EXPECTED_HASH="..."

if [ "$HASH" != "$EXPECTED_HASH" ]; then
  echo "產物不一致，請重新生成"
  exit 1
fi''',
              ),
              const SizedBox(height: 16),
              _StrategyCard(
                title: '方法 3：強制執行生成',
                description: '每次 CI 都執行生成，確保產物最新',
                steps: [
                  'CI 每次執行時都跑生成指令',
                  '生成的檔案自動 commit（可選）',
                  '或檢查是否有變更',
                ],
                example: r'''# 每次 CI 都執行
- run: |
    for f in pigeons/*.dart; do
      dart run pigeon --input "$f"
    done
- run: flutter test''',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '自動化工具',
            children: [
              _ToolCard(
                title: 'Makefile',
                description: '使用 Makefile 定義生成指令',
                example: r'''# Makefile
pigeon:
	@for f in pigeons/*.dart; do \
		dart run pigeon --input "$$f"; \
	done

.PHONY: pigeon''',
              ),
              const SizedBox(height: 12),
              _ToolCard(
                title: 'File Watchers',
                description: 'IDE 設定，檔案存檔時自動執行',
                example: r'''# IntelliJ/Android Studio
# Settings > Tools > File Watchers
# 新增 watcher：
# - File type: Dart
# - Scope: pigeons/
# - Program: dart
# - Arguments: run pigeon --input $FilePath$''',
              ),
              const SizedBox(height: 12),
              _ToolCard(
                title: 'Pre-commit Hook',
                description: '提交前自動檢查',
                example: r'''#!/bin/sh
# .git/hooks/pre-commit

# 檢查是否有介面檔變更
if git diff --cached --name-only | grep -q "pigeons/"; then
  echo "檢測到 Pigeon 介面變更，執行生成..."
  for f in pigeons/*.dart; do
    dart run pigeon --input "$f"
  done
  git add lib/pigeons/
fi''',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'CI 與可維護性',
            children: [
              const Text(
                'CI 整合與可維護性密切相關：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.link, color: Colors.teal.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'CI 如何提升可維護性',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• 自動化檢查：減少人為遺漏生成指令\n'
                        '• 一致性保證：確保所有成員使用相同的產物\n'
                        '• 早期發現：在合併前發現問題\n'
                        '• 減少溝通成本：不需要提醒團隊成員執行生成\n'
                        '• 降低風險：避免使用過時的產物',
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
            title: '實際案例',
            children: [
              _ExampleCard(
                title: '案例 1：GitHub Actions',
                description: '在 PR 時檢查 Pigeon 產物',
                code: r'''name: Check Pigeon

on:
  pull_request:
    paths:
      - 'pigeons/**'

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - name: Generate Pigeon code
        run: |
          for f in pigeons/*.dart; do
            dart run pigeon --input "$f"
          done
      - name: Check for changes
        run: |
          if [ -n "$(git status --porcelain)" ]; then
            echo "❌ Pigeon 產物未同步"
            echo "請執行以下指令："
            echo "  for f in pigeons/*.dart; do"
            echo "    dart run pigeon --input \$f"
            echo "  done"
            git diff
            exit 1
          fi
          echo "✅ Pigeon 產物已同步''',
              ),
              const SizedBox(height: 16),
              _ExampleCard(
                title: '案例 2：GitLab CI',
                description: '在 CI pipeline 中整合',
                code: r'''pigeon-check:
  stage: test
  script:
    - |
      for f in pigeons/*.dart; do
        dart run pigeon --input "$f"
      done
    - |
      if [ -n "$(git diff)" ]; then
        echo "Pigeon 產物未同步"
        exit 1
      fi''',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '最佳實踐',
            children: [
              _BulletPoint(
                '鎖定版本',
                [
                  '在 pubspec.yaml 中鎖定 pigeon 版本',
                  '避免不同環境使用不同版本',
                  '升級時可以透過 CI 驗證',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '明確的錯誤訊息',
                [
                  'CI 失敗時提供清楚的錯誤訊息',
                  '告訴開發者如何修復',
                  '提供執行指令的範例',
                ],
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                '漸進導入',
                [
                  '可以先在 pre-commit 或本地腳本開始',
                  '逐步加入 CI 檢查',
                  '讓團隊適應流程',
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

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.title,
    required this.description,
    required this.steps,
    required this.example,
  });

  final String title;
  final String description;
  final List<String> steps;
  final String example;

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
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              '步驟：',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...steps.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key + 1}. ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '範例：',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    example,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
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

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.title,
    required this.description,
    required this.example,
  });

  final String title;
  final String description;
  final String example;

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
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '設定方式：',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    example,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
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

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.code,
  });

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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

