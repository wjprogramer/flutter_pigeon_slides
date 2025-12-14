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

/// 靜態 QA 資料，來源為 notes/qa.md
const qaSections = <QaSection>[
  QaSection(
    title: '生產力 / 開發速度與程式碼量',
    items: [
      QaItem(
        question: '不熟 Pigeon 的人開發會變慢；Method Channel 是基礎且多人會，開發更順？',
        answer: [
          '初期學習：Pigeon 需要熟悉介面註解與生成流程，短期可能稍慢；但接口一旦定義好，Client/Host 樣板由工具產生，減少後續維護成本。',
          '型別安全收益：避免字串/欄位 typo、強制轉型錯誤，降低除錯時間；錯誤封裝一致，支援堆疊資訊，有助線上排錯。',
          '團隊習慣：Method Channel 技能普及，適合一次性、小型需求；Pigeon 較適合持續演進、介面多的場景，可先小範圍導入觀察。',
          '文件/培訓：提供最小範例與一鍵腳本（生成指令），縮短新人上手時間；保留 Method Channel 範例作對照，便於溝通取捨。',
          '速度結論：首條/小型 API 開發，Method Channel 往往最快；多 API、頻繁演進或多人協作時，Pigeon 透過型別安全與自動樣板生成，減少後續同步/除錯成本，長期更省時。',
        ],
      ),
      QaItem(
        question: '介面少就不用 Pigeon 了吧？',
        answer: [
          '小而穩定的單一方法，手寫確實最快；但只要預期會「持續演進或成長」，越早建立契約與生成流程，後續增欄位/enum 時成本更低。',
          '型別安全與錯誤封裝的價值不只在數量，也在降低 typo/欄位漏改的風險；即便 1-2 條 API，也能避免字串 channel/method/Map key 的隱性錯。',
          '團隊協作與交接：有介面檔就有明確契約，新人接手不必反推 Map 結構；對外展示/審查時也較清楚。',
          '折衷做法：若確定是一次性、單端、不會演進的小工具，可手寫；但對「會再長大」或「需多人維護」的功能，仍建議用 Pigeon 打基礎。',
        ],
      ),
      QaItem(
        question: '目前只有單一平台（如 macOS），而且不確定未來會不會加其他平台的同類功能——還建議用 Pigeon 嗎？同一個 Pigeon class 的方法若平台支援不一致會不會很怪？',
        answer: [
          '仍可用 Pigeon 的理由：核心價值在「介面契約 + 型別安全 + 一致錯誤封裝」，即便單平台也能避免 channel/method/Map key typo 與欄位漏改；介面演進時有產物 diff、型別約束降低回歸風險。',
          '何時優先用：介面會演進、資料結構不簡單、多人協作或長期維護；即使暫時單平台，之後若補其他平台可直接沿用介面契約。',
          '何時可手寫：一次性、極簡、確定不演進的小功能，且同一人掌握 Flutter/原生；但同一模組內避免混用，需標註例外理由。',
          '平台支援不一致的處理：一個 Pigeon class 代表同語意介面，允許部分方法單平台；在介面/註解/README 標註支援矩陣與 fallback（例如回傳 not supported），避免「一方法一 class」爆炸，同時保留在未來補齊其他平台的彈性。',
        ],
      ),
      QaItem(
        question: '你能證明 Pigeon 在多 API/多人協作時真的更快嗎？會不會只是推論？',
        answer: [
          '官方說法：Flutter 官方文件（Pigeon 章節）指出其目標是產生 type-safe 雙端碼、減少樣板與命名/欄位錯誤；意即省去手寫序列化、常數命名與錯誤包裝的重複工。',
          '建議實證：以同一批 API 做小型實驗（Method Channel vs Pigeon），記錄：',
          '  - LOC/樣板對比：手寫雙端資料封裝與錯誤處理的程式碼量 vs 介面檔 + 生成產物。',
          '  - 缺陷/除錯：型別/欄位 typo、PlatformException 格式錯誤等問題數與修復時間。',
          '  - 變更迭代：欄位或 enum 變動時，雙端同步與錯誤處理的耗時差異。',
          '沒有數據前不宣稱必然更快，可表述為「減少樣板與 typo/序列化錯誤的來源，預期可降低維護成本」，並用實驗結果佐證。',
        ],
      ),
      QaItem(
        question: '要怎麼實證？需要用人力做對照嗎？',
        answer: [
          '最小實驗設計：挑同一組 API（含 1-2 個物件、1-2 個方法），由同一位開發者分別用 Method Channel 與 Pigeon 完成 Client/Host，計時並記錄：',
          '  - 開發時間（含跑通基本測試）。',
          '  - 產出 LOC/樣板量。',
          '  - 缺陷數與修復時間（如欄位/型別/錯誤封裝）。',
          '迭代測試：在上述 API 增減欄位或 enum，重做同步，記錄時間與錯誤。',
          '協作模擬（選做）：兩人分工（Flutter/原生）各自實作並同步，觀察溝通/對齊成本；Pigeon 產物可作為契約，預期同步成本較低。',
        ],
      ),
      QaItem(
        question: '有沒有可能 Method Channel 反而比較久（或比較快）？有相關討論嗎？',
        answer: [
          '可能比較快的情境：單一/少量 API、純 primitive 參數與回傳、錯誤格式不需統一，且團隊已熟 Method Channel；此時手寫最少樣板，上手成本低。',
          '可能比較久的情境：',
          '  - API/資料結構變多、常變更：雙端手動同步欄位/enum、錯誤封裝與序列化，易漏改；Pigeon 以介面為單一真相來源，生成雙端碼，變更成本較低。',
          '  - 型別安全與可讀性要求高：手寫要維護大量 as/Map key/Channel name/method name，除錯時間增；Pigeon 生成型別安全碼並減少字串常數。',
          '  - 協作：多人同時改 Flutter/原生，手寫需對齊契約；Pigeon 產生碼直接給出契約，降低對齊成本。',
          '討論/實務：常見建議是「小而快的 PoC 用 Method Channel；介面較大或長期維護的模組考慮 Pigeon」。若要佐證，可依前述實驗量測時間、缺陷與變更耗時。',
        ],
      ),
      QaItem(
        question: '同一個需求下，手寫程式碼量誰比較多？',
        answer: [
          '估算標準：不計生成碼；只比較「人手寫」的部分（介面定義、手寫序列化、錯誤處理、註冊、業務邏輯）。',
          'Method Channel：需手寫 channel/method 名稱、Map key 序列化/反序列化、錯誤包裝，Flutter/原生各一份，欄位多時樣板成長快。',
          'Pigeon：手寫 Dart 介面（資料類型 + 註解）與 Host/Flutter 端實作業務邏輯；序列化/錯誤封裝與呼叫樣板由生成碼提供，欄位增長時人手碼量較平緩。',
          '小型單一方法：Method Channel 可能略少（因為介面檔 + 生成步驟）；但隨 API/欄位/enum 增加，Pigeon 的人手樣板增長比手寫通道慢。',
        ],
      ),
      QaItem(
        question: '除了程式碼數量，還有哪些影響開發速度的客觀因素？',
        answer: [
          'API/欄位變更頻率：變更越頻繁，雙端同步與錯誤封裝的成本越顯著，Pigeon 的生成優勢會放大。',
          '型別複雜度：巢狀物件、enum、nullable 欄位、錯誤格式統一需求越多，手寫成本與除錯時間上升。',
          '工具自動化程度：是否有一鍵 script/Makefile/File Watcher/CI 驗證介面與產物；自動化越完整，生成流程越不阻塞。',
          '團隊熟悉度：Method Channel 普及但容易有隱性錯誤；Pigeon 初學成本較高，但介面清晰、約束強，後續協作/Review 時間可縮短。',
          '平台數量：多平台時，手寫需重複實作；Pigeon 介面一次定義，生成多端碼，跨平台同步成本下降（本專案實作聚焦 macOS，但仍可展示概念）。',
          '除錯/回歸成本：型別/欄位/錯誤封裝錯誤帶來的除錯時間；可觀察線上/測試階段問題數與修復時間。',
        ],
      ),
    ],
  ),
  QaSection(
    title: '可讀性與審查策略',
    items: [
      QaItem(
        question: 'Pigeon 生成碼可讀性不高，包了很多東西，channel name 也很長？',
        answer: [
          '生成碼取向：Pigeon 產物偏「工具碼」，以完整性與型別安全為優先；可讀性較手寫精簡碼差，但重點是讓雙端一致、避免隱性錯誤。',
          '長 channel name：為避免衝突與表意清楚，會帶 namespace。若在 demo/投影片需要簡潔，可在產物外層包一層 facade，或在展示時聚焦介面檔（Dart 定義）而非產物全貌。',
          '學習/溝通：可只 review 介面檔與 Host/Flutter 實作邏輯，生成碼視為編譯產物；必要時挑選關鍵段落（如 codec read/write、錯誤封裝）展示其機制，而非整檔逐行閱讀。',
        ],
      ),
      QaItem(
        question: '手寫 Channel 時，channel name 容易衝突或命名不清晰嗎？Pigeon 的長名稱是否算優點？',
        answer: [
          '風險來源：手寫時 channel/method 名稱多為自由字串，若缺乏命名規範與檢查，衝突或 typo 難被及早發現。',
          'Pigeon 的優勢：產物會帶 namespace/前綴，降低衝突機率，並以介面檔為單一真相來源，Flutter/原生同名同義。',
          '手寫的補救：制定命名規範（含前綴/命名空間），加 lint/常數集中管理；否則隨著模組增長，命名衝突與難以追蹤的 typo 風險上升。',
        ],
      ),
      QaItem(
        question: '只 review 介面檔與實作，不看生成碼，是不是不負責任？',
        answer: [
          '原則：生成碼屬「工具產物」，重點在「生成規則正確」與「輸出被測試覆蓋」。負責任的做法是：review 介面/業務實作 + 驗證生成流程與測試，而非逐行人工檢閱產物。',
          '減少風險的手段：',
          '  - 鎖定 pigeon 版本、固定生成指令與輸出路徑，避免環境漂移。',
          '  - 在 CI 跑生成 + 測試，並比對產物（或 hash）確保一致；若生成碼變動，PR diff 會顯示，仍可針對關鍵片段抽查。',
          '  - 如需深入，聚焦 codec 實作與錯誤封裝片段，驗證關鍵行為即可。',
          '對照標準做法：類似 protobuf/graphQL/ORM 的 codegen，通常 review 契約/Schema 與業務實作，生成碼靠工具穩定性與測試保障；不是忽視，而是用自動化與抽查降低人工成本。',
        ],
      ),
      QaItem(
        question: '我熟悉手寫 Channel，對自己寫的每行程式碼能負責；被迫用 Pigeon 生成碼，我無法保證它的品質，會增加專案風險？',
        answer: [
          '責任界線：Pigeon 產物的品質取決於介面定義 + 工具版本；對「契約與業務實作」負責，並透過固定版本與 CI 確保生成一致性，是可控的工程責任分工。',
          '穩定性來源：Pigeon 是官方維護、以樣板生成的靜態碼，不使用反射，行為可預期；生成碼可讀（Kotlin/Swift/Dart），必要時可抽查或比對產物 diff。',
          '風險管控做法：',
          '  - 鎖定 pigeon 版本並記錄生成指令與輸出路徑；生成碼納入 PR diff 讓 reviewer 可抽查關鍵段落。',
          '  - CI 驗證：介面變更 → 強制跑 codegen → 測試；如有破壞性升級，可回退或鎖版。',
          '  - 若對關鍵路徑有疑慮，可在早期抽樣 review 編解碼/錯誤封裝片段，確認無隱患後再信任樣板。',
          '回退與應變：若某版生成有問題，可快速鎖回上一版或暫時以手寫覆寫；生成碼可作為參考邏輯，最終仍可回到手寫，不會被鎖死。',
          '可讀性立場：Pigeon 產生的就是傳統 Channel/codec 實作的樣板，熟悉 Channel 的人能看懂；官方也表明產物是可讀的。若覺得冗長，可聚焦介面檔與關鍵片段（編解碼、錯誤封裝）抽查，不必逐行審整檔。',
          '團隊角度：個人熟練手寫並不保證團隊一致性；Pigeon 的命名規範與介面契約降低跨人協作時的衝突與 typo 風險，是在「多人維護」場景下的風險緩解手段。',
          '例外政策：可保留「一次性、極簡、確定不演進且同一人掌握」的小需求用手寫，但 PR 必須說明例外理由；其他新需求預設用 Pigeon，避免路徑依賴讓新功能又回到手寫。',
        ],
      ),
    ],
  ),
  QaSection(
    title: '效能',
    items: [
      QaItem(
        question: '效能方面，Pigeon 會不會比較慢？包了一堆生成碼會影響嗎？',
        answer: [
          '核心開銷在編解碼：Pigeon 與手寫 Method Channel 預設都用 StandardMessageCodec，序列化成本相同；差異只在薄薄的 wrapper。',
          '生成碼是靜態樣板：型別檢查與錯誤封裝在編譯期展開，runtime 不額外使用反射或動態解析；開銷接近手寫。',
          '熱路徑考量：若需高頻/大資料量溝通，兩者都受標準 codec 限制；可考慮自訂 codec、二進位格式，或改用 dart:ffi 直呼 native。',
          '實測方式：在 macOS 目標下，以相同 payload/次數做訊息吞吐/延遲 micro-benchmark，對比 Pigeon 生成碼 vs 手寫 Method Channel；多數情況差異落在誤差範圍。',
        ],
      ),
    ],
  ),
  QaSection(
    title: '測試',
    items: [
      QaItem(
        question: '哪種方式比較容易測試？',
        answer: [
          'Pigeon 的優勢：',
          '  - 型別安全介面可直接 mock（如 `DeviceApi`），IDE 自動完成與型別檢查明確。',
          '  - 錯誤封裝格式一致，測錯誤情境時不必自訂多種 `PlatformException` 變體。',
          '  - 介面契約清晰，測試聚焦業務邏輯，少碰 channel/method 字串。',
          'Method Channel 的優勢：',
          '  - 不需 codegen，測試環境設定簡單。',
          '  - 可用 `MethodChannel.setMockMethodCallHandler` 直接模擬 channel 行為，撰寫 stub/mock 直觀。',
          'Pigeon 的成本：需要先跑 codegen（本地或 CI），測試流程須包含生成步驟。',
          'Method Channel 的風險：字串易 typo，Map 序列化/反序列化與錯誤格式需手動維護，測試時易出現欄位/格式不一致。',
          '結論：若已有 codegen 流程且在意型別安全與一致的錯誤封裝，Pigeon 測試體驗通常較佳；若僅小型 PoC、追求零前置步驟，Method Channel 較快上手，但需防範字串與格式錯誤。',
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
          '開發時間對照：同一組 API（1-2 物件、1-2 方法），同一開發者分別用 Method Channel 與 Pigeon，計時含基本測試。',
          '程式碼量對照：記錄人手撰寫的 LOC/樣板（不含生成碼）；欄位/enum 增加時再次比較增量。',
          '缺陷與除錯：統計欄位/型別/錯誤封裝相關問題數與修復時間，對照兩種做法。',
          '變更迭代成本：對同一組 API 做欄位或 enum 變更，記錄雙端同步與錯誤處理的耗時差異。',
          '協作成本（選做）：兩人分工 Flutter/原生，各自實作並同步，觀察對齊與修正成本。',
          '效能微基準：在 macOS 下以相同 payload/次數，測量吞吐與延遲，對比 Pigeon 生成碼 vs 手寫 Method Channel；如需高頻情境，可再測自訂 codec 或 dart:ffi。',
        ],
      ),
    ],
  ),
];
