import 'package:flutter/material.dart';

class PigeonAdoptionPage extends StatelessWidget {
  const PigeonAdoptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('導入 Pigeon 的策略'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '是否應該導入 Pigeon？',
            children: [
              _DecisionCard(
                title: '✅ 適合導入的情況',
                color: Colors.green,
                items: [
                  '專案需要頻繁與原生平台溝通',
                  '團隊重視類型安全和編譯期檢查',
                  '需要維護多個平台（Android、iOS、macOS 等）',
                  '團隊規模較大，需要清晰的接口定義',
                  '專案需要長期維護，重視可維護性',
                  '希望減少運行時錯誤和調試時間',
                  '團隊已有 Dart/Flutter 開發經驗',
                ],
              ),
              const SizedBox(height: 16),
              _DecisionCard(
                title: '⚠️ 需要謹慎考慮的情況',
                color: Colors.orange,
                items: [
                  '專案中與原生平台的溝通非常少（< 5 個方法）',
                  '團隊對 Dart 和 Flutter 還不熟悉',
                  '專案即將結束，不需要長期維護',
                  '現有的 Standard Channels 實作已經穩定且運作良好',
                  '團隊資源有限，無法投入學習新工具',
                ],
              ),
              const SizedBox(height: 16),
              _DecisionCard(
                title: '❌ 可能不適合的情況',
                color: Colors.red,
                items: [
                  '專案只使用 Web 平台（Pigeon 不支援 Web）',
                  '需要動態的、運行時才決定的方法調用',
                  '專案規模極小，只有 1-2 個簡單的原生方法',
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '導入策略',
            children: [
              _StrategyCard(
                title: '策略 1：漸進式導入（推薦）',
                icon: Icons.trending_up,
                color: Colors.blue,
                description: '在新功能中逐步採用 Pigeon，保留現有 Standard Channels 實作',
                steps: [
                  '選擇一個新的功能模組作為試點',
                  '使用 Pigeon 實作該模組的原生溝通',
                  '收集團隊反饋，評估效果',
                  '逐步擴展到其他新功能',
                  '舊功能保持不變，除非需要重大重構',
                ],
                pros: [
                  '風險低，不影響現有功能',
                  '團隊可以逐步學習',
                  '可以對比 Pigeon 與 Standard Channels 的實際效果',
                ],
                cons: [
                  '專案中會同時存在兩種方式',
                  '需要維護兩套實作',
                ],
              ),
              const SizedBox(height: 16),
              _StrategyCard(
                title: '策略 2：新專案全面導入',
                icon: Icons.new_releases,
                color: Colors.green,
                description: '在新專案中直接採用 Pigeon 作為標準方案',
                steps: [
                  '在專案初期就決定使用 Pigeon',
                  '建立專案模板和最佳實踐',
                  '所有原生溝通都使用 Pigeon',
                  '建立 CI/CD 流程確保代碼生成',
                ],
                pros: [
                  '統一技術棧，減少混亂',
                  '團隊從一開始就建立正確的習慣',
                  '避免技術債務',
                ],
                cons: [
                  '需要團隊成員快速學習',
                  '初期可能影響開發速度',
                ],
              ),
              const SizedBox(height: 16),
              _StrategyCard(
                title: '策略 3：全面遷移',
                icon: Icons.transform,
                color: Colors.purple,
                description: '將現有專案的所有 Standard Channels 遷移到 Pigeon',
                steps: [
                  '評估現有 Standard Channels 的複雜度',
                  '制定詳細的遷移計劃',
                  '按模組逐步遷移',
                  '充分測試每個遷移的模組',
                  '更新文檔和培訓材料',
                ],
                pros: [
                  '統一技術棧',
                  '長期維護成本更低',
                ],
                cons: [
                  '需要大量時間和資源',
                  '風險較高，可能影響現有功能',
                  '需要充分的測試和回歸驗證',
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '導入考量因素',
            children: [
              _FactorCard(
                title: '團隊技能評估',
                icon: Icons.people,
                color: Colors.blue,
                content: [
                  '團隊對 Dart/Flutter 的熟悉程度',
                  '團隊對原生平台（Android/iOS）的了解',
                  '是否有足夠的學習時間和資源',
                  '是否需要額外的培訓',
                ],
              ),
              const SizedBox(height: 12),
              _FactorCard(
                title: '專案特性',
                icon: Icons.description,
                color: Colors.orange,
                content: [
                  '專案的生命週期（短期 vs 長期）',
                  '與原生平台溝通的頻率和複雜度',
                  '專案的維護需求',
                  '是否需要支援多個平台',
                ],
              ),
              const SizedBox(height: 12),
              _FactorCard(
                title: '組織因素',
                icon: Icons.business,
                color: Colors.purple,
                content: [
                  '組織對新技術的接受度',
                  '是否有明確的技術決策流程',
                  '資源分配和時間安排',
                  '與其他團隊的協作需求',
                ],
              ),
              const SizedBox(height: 12),
              _FactorCard(
                title: '技術債務',
                icon: Icons.build,
                color: Colors.red,
                content: [
                  '現有 Standard Channels 的問題嚴重程度',
                  '重構的成本和收益',
                  '是否值得投入時間遷移',
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '導入計劃範例',
            children: [
              const Text(
                '以下是一個漸進式導入的計劃範例：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              _TimelineCard(
                phase: '第一階段：準備（1-2 週）',
                tasks: [
                  '團隊技術分享，介紹 Pigeon 的概念和優勢',
                  '選擇一個低風險的功能作為試點',
                  '建立開發環境和 CI/CD 流程',
                  '準備培訓材料和文檔',
                ],
              ),
              const SizedBox(height: 12),
              _TimelineCard(
                phase: '第二階段：試點（2-4 週）',
                tasks: [
                  '實作試點功能，使用 Pigeon',
                  '收集團隊反饋和使用體驗',
                  '評估開發效率和代碼品質',
                  '記錄遇到的問題和解決方案',
                ],
              ),
              const SizedBox(height: 12),
              _TimelineCard(
                phase: '第三階段：擴展（持續）',
                tasks: [
                  '將 Pigeon 應用到更多新功能',
                  '建立團隊最佳實踐和規範',
                  '持續優化和改進流程',
                  '考慮是否遷移舊功能',
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '常見疑慮與解答',
            children: [
              _QACard(
                question: '團隊只有少數人會 Pigeon，不應該導入？',
                answer: [
                  '學習成本主要在 Dart 介面與生成流程；Host 端多為套用產生碼，少數人維護介面/指令即可。',
                  '風險控管：在 repo 放置生成指令/腳本（如 make、File Watcher），CI 可檢查「介面改了但產物未更新」以防漏跑。',
                  '漸進導入：先用在新 API 或低風險區域，既有 MethodChannel 不動，逐步觀察收益。',
                  '回退策略：介面清晰、產物可讀（Kotlin/Swift/Dart），若不續用，可回到手寫 Channels 並沿用邏輯。',
                  '說服點：型別安全與統一錯誤封裝能減少線上事故；生成碼視為工具輸出，不需人人深讀。',
                ],
              ),
              const SizedBox(height: 12),
              _QACard(
                question: '生成碼需要額外工具與流程，會增加開發負擔？',
                answer: [
                  '程序化處理：用腳本/Makefile/File Watcher 自動跑 pigeon；CI 檢查介面變更未同步產物，避免漏跑。',
                  '對比手寫 Channels：手動維護 method/channel 名稱、參數/回傳與錯誤格式，本身也有隱性流程且更易 typo/漏欄位；顯式 codegen 換來型別安全與一致性。',
                  '人力需求：只需少數人熟悉介面檔與指令，多數人僅呼叫生成後 API。',
                  '回退彈性：生成碼可讀（Kotlin/Swift/Dart），若不續用可參考生成邏輯改回手寫。',
                ],
              ),
              const SizedBox(height: 12),
              _QACard(
                question: '沒有現成 CI 檢查 pigeon 產物，同步風險高，是否先等 CI 才導入？',
                answer: [
                  '建議：先排一個 task 在 CI 針對 `pigeons`/介面檔改動時跑 `dart run pigeons ...` 或比對產物（可用 hash/檔案 diff），未同步就 fail，這樣最安全。',
                  '過渡做法：在導入初期先用 pre-commit/本地腳本或 PR checklist 強制執行；同時安排 CI 任務盡快補上。',
                  '取捨：CI 缺席時仍可先小範圍導入（低風險 API），但要嚴格執行腳本與 code review 檢查產物更新。',
                ],
              ),
              const SizedBox(height: 12),
              _QACard(
                question: '漸進導入會讓專案同時有 Pigeon 和手寫 Method Channel，風格不一致？',
                answer: [
                  '分區域導入：先鎖定新模組/新 API 用 Pigeon，舊區域暫時保持手寫，避免交錯同檔案。',
                  '訂規範：channel 命名、錯誤格式、資料結構在文件/README 訂清楚；Pigeon 區域用介面檔為唯一來源，手寫區域遵守同一命名/錯誤格式，以降低風格落差。',
                  '設過渡期限：在路線圖標記「哪些模組會逐步遷移、哪些保留手寫」，並在 PR 模板提醒「新 API 優先用 Pigeon，除非有理由」。',
                  '工具輔助：可在 lint/pre-commit 加入「新檔若落在指定資料夾須有 Pigeon 介面」或在 code review checklist 明示；減少隨意混用。',
                  '最終策略：等 CI/流程穩定後，挑時間把高變動區域遷移，低變動/legacy 模組可留手寫，但標註維護策略與責任人，避免風格漂移無人收斂。',
                ],
              ),
              const SizedBox(height: 12),
              _QACard(
                question: '這樣不就變成最後都要換成 Pigeon？若只換一部分，風格仍不一致，為什麼不全部保持傳統 Method Channel？',
                answer: [
                  '非必然全量遷移：若既有模組穩定、變更少且團隊已熟手寫通道，可維持現狀；Pigeon 優先用在「新增或高變動介面」以降低同步與型別錯誤風險。',
                  '避免多套混亂：訂一條「首選」原則：新/高變動 API 用 Pigeon；老且低變動區維持手寫，但同一模組內避免混用兩種方式。',
                  '取捨標準：介面複雜度高（巢狀物件/enum/nullable 多）、頻繁增減欄位、多人協作或需跨端同步速度快時，用 Pigeon；簡單、單端、自用工具或一次性 PoC 可用手寫。',
                  '收斂節奏：每季/里程碑檢視是否需要把高變動區域從手寫搬到 Pigeon；不要為了「一致」強遷穩定區，但也避免無節制新增手寫通道。',
                  '成本與收益：Pigeon 的價值在型別安全、錯誤封裝一致、雙端同步降低溝通成本；若需求不符合這些痛點，保留傳統寫法是合理選項。',
                ],
              ),
              const SizedBox(height: 12),
              _QACard(
                question: '新需求如果很簡單就用 Channel，之後相同類別的新需求也會沿用 Channel，結果永遠用不到 Pigeon？',
                answer: [
                  '設「新需求默認用 Pigeon」的原則（非 PoC/一次性工具除外），避免因首次偷懶形成路徑依賴。',
                  '如果舊功能已用 Channel，可在同模組設定轉折點：從這次需求開始改用 Pigeon，並註記切換點與理由，逐步把高變動/新功能放到 Pigeon 路徑。',
                  '對簡單需求也可用最小介面檔示範，讓團隊熟悉流程，降低「第一次成本」阻力。',
                  '保留例外條件：PoC、一次性小工具或純單端不需跨端契約時，才允許 Channel，但需在 PR 說明理由，避免默默累積手寫通道。',
                ],
              ),
              const SizedBox(height: 12),
              _QACard(
                question: '多一個套件就是風險；升級 Flutter SDK 時還要擔心 pigeon 相容性，Method Channel 問題較少？',
                answer: [
                  'Pigeon 的套件屬於「建置期依賴」，生成後的程式碼不需在 runtime 引用套件本身，降低執行時風險。',
                  '由 Flutter 官方維護、更新頻率高，通常與 SDK 升版同步跟進；升級策略可採「鎖版本 + 定期檢查 changelog」。',
                  '風險控管：CI 跑 `dart pub upgrade --major-versions`/`dart pub get` 後執行 pigeon，再跑測試；若出現破壞性變更，可先鎖定舊版或回退生成流程。',
                  'Method Channel 也受 SDK/StandardMessageCodec 版本影響（例如型別編碼、錯誤處理行為變化），並非完全無風險；差別是 Pigeon 把兼容性集中在一個官方套件上，升級範圍可控且可透過生成碼 diff 觀察。',
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '成功導入的關鍵',
            children: [
              _KeyPointCard(
                icon: Icons.school,
                title: '培訓與支援',
                content:
                    '確保團隊成員了解 Pigeon 的使用方式和最佳實踐。可以組織技術分享、編寫內部文檔、建立 FAQ。',
              ),
              const SizedBox(height: 12),
              _KeyPointCard(
                icon: Icons.settings,
                title: '工具與流程',
                content:
                    '建立自動化的代碼生成流程，整合到 CI/CD 中。確保開發環境配置正確，減少手動操作。',
              ),
              const SizedBox(height: 12),
              _KeyPointCard(
                icon: Icons.feedback,
                title: '持續改進',
                content:
                    '定期收集團隊反饋，解決遇到的問題。根據實際使用情況調整策略和流程。',
              ),
              const SizedBox(height: 12),
              _KeyPointCard(
                icon: Icons.verified,
                title: '充分測試',
                content:
                    '建立完善的測試流程，確保 Pigeon 實作的正確性。包括單元測試、整合測試和回歸測試。',
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

class _DecisionCard extends StatelessWidget {
  const _DecisionCard({
    required this.title,
    required this.color,
    required this.items,
  });

  final String title;
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
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color.shade700,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 8, color: color.shade700),
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

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.steps,
    required this.pros,
    required this.cons,
  });

  final String title;
  final IconData icon;
  final MaterialColor color;
  final String description;
  final List<String> steps;
  final List<String> pros;
  final List<String> cons;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            _SubSection(title: '實施步驟', items: steps),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _SubSection(
                    title: '優點',
                    items: pros,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SubSection(
                    title: '缺點',
                    items: cons,
                    color: Colors.orange,
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

class _SubSection extends StatelessWidget {
  const _SubSection({
    required this.title,
    required this.items,
    this.color,
  });

  final String title;
  final List<String> items;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
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
                  style: TextStyle(color: color),
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
    );
  }
}

class _FactorCard extends StatelessWidget {
  const _FactorCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
  });

  final String title;
  final IconData icon;
  final MaterialColor color;
  final List<String> content;

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
            ...content.map(
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

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.phase,
    required this.tasks,
  });

  final String phase;
  final List<String> tasks;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phase,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...tasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_right, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task,
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

class _QACard extends StatelessWidget {
  const _QACard({
    required this.question,
    required this.answer,
  });

  final String question;
  final List<String> answer;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.help_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...answer.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(color: Colors.grey),
                    ),
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

class _KeyPointCard extends StatelessWidget {
  const _KeyPointCard({
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
            Icon(icon, color: Colors.blue.shade700),
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

