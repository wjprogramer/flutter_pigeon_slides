class QaItem {
  const QaItem({required this.question, required this.answer});
  final String question;
  final List<String> answer;
}

class QaSection {
  const QaSection({required this.title, required this.items});
  final String title;
  final List<QaItem> items;
}

/// 靜態 QA 資料，來源為 notes/qa.md（可與原檔不同步）。
const qaSections = <QaSection>[
  QaSection(
    title: '導入與流程 / CI',
    items: [
      QaItem(
        question: '團隊只有少數人會 Pigeon，不應該導入？',
        answer: [
          '學習成本主要在介面定義/生成流程；少數人維護指令即可。',
          '工具化：腳本/CI 檢查介面變更未同步產物。',
          '漸進導入，新 API 先用，舊區域保持手寫。',
        ],
      ),
      QaItem(
        question: '生成碼流程會加重負擔？',
        answer: [
          '自動化：Makefile/File Watcher/CI 跑 pigeon。',
          '手寫 Channels 同樣有同步/typo 風險，顯式 codegen 換型別安全。',
        ],
      ),
      QaItem(
        question: '沒有 CI 檢查產物，同步風險高？',
        answer: [
          '安排 CI：介面改動就跑 pigeon 或比對產物，未同步即 fail。',
          '過渡：pre-commit/PR checklist 強制執行。',
        ],
      ),
      QaItem(
        question: '漸進導入會造成風格不一致？',
        answer: [
          '區分模組導入，避免同檔混用；訂 channel/錯誤格式規範。',
          '新需求預設用 Pigeon，舊的低風險區可暫留手寫。',
        ],
      ),
      QaItem(
        question: '會不會最後全都要換成 Pigeon？',
        answer: [
          '不必強遷穩定區；高變動/新 API 優先 Pigeon，低變動可留手寫但標註策略。',
        ],
      ),
      QaItem(
        question: '簡單需求用 Channel，之後都沿用 Channel？',
        answer: [
          '訂「新需求預設 Pigeon」原則；PoC/一次性可例外但需 PR 說明。',
        ],
      ),
      QaItem(
        question: '多一個套件就是風險，升級怕不相容？',
        answer: [
          'Pigeon 為建置期依賴，產物不需 runtime 套件。',
          '官方維護，鎖版本+changelog+CI 驗證；手寫也受 codec/SDK 版本影響。',
        ],
      ),
    ],
  ),
  QaSection(
    title: '生產力 / 開發速度與程式碼量',
    items: [
      QaItem(
        question: '不熟 Pigeon 會變慢？MethodChannel 比較順？',
        answer: [
          '首條 API 可能稍慢；介面定義後樣板由工具產生，後續維護成本低。',
          '型別安全減少 typo/欄位漏改，省除錯時間。',
        ],
      ),
      QaItem(
        question: '介面少就不用 Pigeon？',
        answer: [
          '一次性極簡可手寫；若預期演進或多人維護，越早建立契約越好。',
        ],
      ),
      QaItem(
        question: '單一平台還需要 Pigeon？',
        answer: [
          '價值在契約/型別安全/一致錯誤封裝，即便單平台也能減少漏改。',
          '預期演進或日後加平台時，可直接沿用介面。',
        ],
      ),
      QaItem(
        question: '如何實證開發速度？',
        answer: [
          '同一開發者對同組 API 以兩種方式實作，記錄時間/LOC/缺陷/變更耗時。',
        ],
      ),
      QaItem(
        question: '手寫程式碼量 vs Pigeon？',
        answer: [
          '不計生成碼；手寫需維護 channel/method/Map key/錯誤封裝，欄位多時樣板爆炸。',
          'Pigeon 手寫介面 + 業務邏輯，增欄位時人手樣板成長較慢。',
        ],
      ),
      QaItem(
        question: '還有什麼影響開發速度的因素？',
        answer: [
          'API 變更頻率、型別複雜度、自動化程度、團隊熟悉度、平台數量、除錯/回歸成本。',
        ],
      ),
    ],
  ),
  QaSection(
    title: '可讀性與審查',
    items: [
      QaItem(
        question: 'Pigeon 生成碼可讀性差、channel 名很長？',
        answer: [
          '生成碼取向是完整/安全；展示時聚焦介面檔或包一層 facade。',
        ],
      ),
      QaItem(
        question: '手寫 channel 名容易衝突？',
        answer: [
          '手寫靠約定易衝突/typo；Pigeon 產物帶 namespace，契約單一來源減少衝突。',
        ],
      ),
      QaItem(
        question: '只 review 介面檔與實作，不看生成碼是不是不負責任？',
        answer: [
          '生成碼視工具產物，重點在契約正確+CI/測試覆蓋；抽查關鍵片段即可。',
        ],
      ),
      QaItem(
        question: '熟悉手寫的人擔心生成碼品質？',
        answer: [
          '鎖版本、生成指令固定、PR diff 可抽查；若有問題可鎖回或改回手寫。',
          '一次性極簡需求可例外手寫，但需 PR 說明理由。',
        ],
      ),
    ],
  ),
  QaSection(
    title: '效能',
    items: [
      QaItem(
        question: 'Pigeon 會比較慢嗎？',
        answer: [
          '核心開銷在 StandardMessageCodec 編解碼，與手寫相同；生成碼是靜態樣板。',
          '高頻大資料時，兩者都受 codec 限制，可考慮自訂 codec 或 FFI。',
          '需以相同 payload/次數的 micro-benchmark 實測。',
        ],
      ),
    ],
  ),
  QaSection(
    title: '測試',
    items: [
      QaItem(
        question: '哪種比較容易測試？',
        answer: [
          'Pigeon：型別介面可直接 mock，錯誤格式一致，聚焦業務邏輯。',
          'MethodChannel：可 setMockHandler，零 codegen，適合小型 PoC，但易有字串/欄位錯。',
        ],
      ),
    ],
  ),
  QaSection(
    title: '待實測/驗證清單',
    items: [
      QaItem(
        question: '實驗/驗證項目',
        answer: [
          '開發時間對照：同組 API MethodChannel vs Pigeon。',
          '程式碼量：人手撰寫 LOC/樣板增量對比。',
          '缺陷與除錯：型別/欄位/錯誤封裝問題數與修復時間。',
          '變更迭代成本：欄位/enum 變更的同步耗時。',
          '協作成本（選做）：分工實作對齊成本。',
          '效能微基準：相同 payload/次數測吞吐與延遲。',
        ],
      ),
    ],
  ),
];

