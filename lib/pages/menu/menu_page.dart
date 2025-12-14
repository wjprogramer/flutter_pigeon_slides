import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/pages/api_analysis/api_analysis_page.dart';
import 'package:flutter_pigeon_slides/pages/api_count_comparison/api_count_comparison_page.dart';
import 'package:flutter_pigeon_slides/pages/api_doc/api_doc_page.dart';
import 'package:flutter_pigeon_slides/pages/analysis_aspects/analysis_aspects_page.dart';
import 'package:flutter_pigeon_slides/pages/auto_test/auto_test_code_pages.dart';
import 'package:flutter_pigeon_slides/pages/auto_test/auto_test_page.dart';
import 'package:flutter_pigeon_slides/pages/ci_integration/ci_integration_page.dart';
import 'package:flutter_pigeon_slides/pages/compile_time_safety/compile_time_safety_page.dart';
import 'package:flutter_pigeon_slides/pages/demo/demo_page.dart';
import 'package:flutter_pigeon_slides/pages/development_speed/development_speed_page.dart';
import 'package:flutter_pigeon_slides/pages/host_api_testing/host_api_testing_page.dart';
import 'package:flutter_pigeon_slides/pages/learning_curve/learning_curve_page.dart';
import 'package:flutter_pigeon_slides/pages/maintainability/maintainability_page.dart';
import 'package:flutter_pigeon_slides/pages/pigeon_adoption/pigeon_adoption_page.dart';
import 'package:flutter_pigeon_slides/pages/readable/readable_page.dart';
import 'package:flutter_pigeon_slides/pages/settings/settings_page.dart';
import 'package:flutter_pigeon_slides/pages/trending/trending_page.dart';
import 'package:flutter_pigeon_slides/pages/qa/qa_section_page.dart';
import 'package:flutter_pigeon_slides/qa/qa_data.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final _controller = TextEditingController();
  final _allItems = <_Item>[
    // ========== 入口與概覽 ==========
    _Item(
      name: '分析面向',
      page: (_) => const AnalysisAspectsPage(),
      tags: [const _Tag(name: '入口', color: Colors.blue)],
    ),
    
    // ========== 策略與導入 ==========
    _Item(
      name: '導入 Pigeon 的策略',
      page: (_) => const PigeonAdoptionPage(),
      tags: [const _Tag(name: '策略', color: Colors.deepPurple)],
    ),
    
    // ========== 分析面向 ==========
    _Item(
      name: '可讀性 Readable',
      page: (_) => ReadablePage(),
      tags: [const _Tag(name: '分析', color: Colors.green)],
    ),
    _Item(
      name: 'Q&A：可讀性與審查策略',
      page: (_) => QaSectionPage(
        section: qaSections.firstWhere((s) => s.title == '可讀性與審查策略'),
      ),
      tags: [const _Tag(name: '分析', color: Colors.green), const _Tag(name: 'Q&A', color: Colors.grey)],
    ),
    _Item(
      name: '學習曲線',
      page: (_) => const LearningCurvePage(),
      tags: [const _Tag(name: '分析', color: Colors.green)],
    ),
    _Item(
      name: '開發速度',
      page: (_) => const DevelopmentSpeedPage(),
      tags: [const _Tag(name: '分析', color: Colors.green)],
    ),
    _Item(
      name: 'Q&A：生產力 / 開發速度與程式碼量',
      page: (_) => QaSectionPage(
        section: qaSections.firstWhere((s) => s.title == '生產力 / 開發速度與程式碼量'),
      ),
      tags: [const _Tag(name: '分析', color: Colors.green), const _Tag(name: 'Q&A', color: Colors.grey)],
    ),
    _Item(
      name: '可維護性',
      page: (_) => const MaintainabilityPage(),
      tags: [const _Tag(name: '分析', color: Colors.green)],
    ),
    _Item(
      name: '編譯期檢查',
      page: (_) => const CompileTimeSafetyPage(),
      tags: [const _Tag(name: '分析', color: Colors.green)],
    ),
    _Item(
      name: 'CI/CD 整合',
      page: (_) => const CiIntegrationPage(),
      tags: [const _Tag(name: '分析', color: Colors.green)],
    ),
    
    // ========== API 相關 ==========
    _Item(
      name: 'Pigeon API 分析',
      page: (_) => const ApiAnalysisPage(),
      tags: [const _Tag(name: 'API', color: Colors.purple)],
    ),
    _Item(
      name: 'Pigeon 的 API 數量很少',
      page: (_) => const ApiCountComparisonPage(),
      tags: [const _Tag(name: 'API', color: Colors.purple), const _Tag(name: '數據', color: Colors.orange)],
    ),
    _Item(
      name: 'pigeon 文件 API Doc',
      page: (_) => ApiDocPage(),
      tags: [const _Tag(name: 'API', color: Colors.purple)],
    ),
    _Item(
      name: '活躍度與趨勢',
      page: (_) => const TrendingPage(),
      tags: [const _Tag(name: '數據', color: Colors.orange)],
    ),
    
    // ========== 測試相關 ==========
    _Item(
      name: 'HostApi 測試介紹',
      page: (_) => const HostApiTestingPage(),
      tags: [const _Tag(name: '測試', color: Colors.teal)],
    ),
    _Item(
      name: 'Q&A：測試',
      page: (_) => QaSectionPage(
        section: qaSections.firstWhere((s) => s.title == '測試'),
      ),
      tags: [const _Tag(name: '測試', color: Colors.teal), const _Tag(name: 'Q&A', color: Colors.grey)],
    ),
    _Item(
      name: '測試架構說明',
      page: (_) => const AutoTestArchitecturePage(),
      tags: [const _Tag(name: '測試', color: Colors.teal), const _Tag(name: 'code', color: Colors.brown)],
    ),
    _Item(
      name: 'Flutter → 原生測試實作',
      page: (_) => const FlutterToNativeTestPage(),
      tags: [const _Tag(name: '測試', color: Colors.teal), const _Tag(name: 'code', color: Colors.brown)],
    ),
    _Item(
      name: '原生 → Flutter 測試實作',
      page: (_) => const NativeToFlutterTestPage(),
      tags: [const _Tag(name: '測試', color: Colors.teal), const _Tag(name: 'code', color: Colors.brown)],
    ),
    
    // ========== 實作相關 ==========
    _Item(
      name: '原生端實作',
      page: (_) => const NativeImplementationPage(),
      tags: [const _Tag(name: '實作', color: Colors.indigo), const _Tag(name: 'code', color: Colors.brown)],
    ),
    _Item(
      name: 'CounterChannels 實作',
      page: (_) => const CounterChannelsImplementationPage(),
      tags: [const _Tag(name: '實作', color: Colors.indigo), const _Tag(name: 'code', color: Colors.brown)],
    ),
    
    // ========== 效能相關 ==========
    _Item(
      name: 'Auto Perf Runner',
      page: (_) => const AutoTestPage(),
      tags: [const _Tag(name: '效能', color: Colors.deepOrange)],
    ),
    _Item(
      name: 'Q&A：效能',
      page: (_) => QaSectionPage(
        section: qaSections.firstWhere((s) => s.title == '效能'),
      ),
      tags: [const _Tag(name: '效能', color: Colors.deepOrange), const _Tag(name: 'Q&A', color: Colors.grey)],
    ),
    
    // ========== 工具與示範 ==========
    _Item(
      name: 'Demo / Perf',
      page: (_) => DemoPage(),
      tags: [const _Tag(name: '示範', color: Colors.cyan)],
    ),
    
    // ========== 其他 Q&A ==========
    _Item(
      name: 'Q&A：待實測/驗證清單',
      page: (_) => QaSectionPage(
        section: qaSections.firstWhere((s) => s.title == '待實測/驗證清單'),
      ),
      tags: [const _Tag(name: 'Q&A', color: Colors.grey)],
    ),
  ];

  Widget _button(BuildContext context, _Item item) {
    List<InlineSpan> subtitleSpans = [];

    if (item.tags.isNotEmpty) {
      subtitleSpans.add(WidgetSpan(child: SizedBox(width: 8)));
      for (var i = 0; i < item.tags.length; i++) {
        if (i > 0) {
          subtitleSpans.add(WidgetSpan(child: SizedBox(width: 4)));
        }
        subtitleSpans.add(WidgetSpan(child: _TagView(item.tags[i])));
      }
    }

    return ListTile(
      title: Text(item.name),
      subtitle: subtitleSpans.isNotEmpty
          ? RichText(
              // style: Theme.of(context).textTheme.bodyMedium,
              text: TextSpan(children: subtitleSpans),
            )
          : null,
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        if (item.page != null) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => item.page!(context)));
        }
      },
    );
  }

  List<_Item> _filterItems(String? query) {
    final resolvedQuery = query?.trim().toLowerCase();
    if (resolvedQuery == null || resolvedQuery.isEmpty) {
      return _allItems;
    }
    return _allItems
        .where((e) => e.name.toLowerCase().contains(resolvedQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filterItems(_controller.text);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            tooltip: '設定',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: '關鍵字'),
            onChanged: (_) {
              setState(() {});
            },
          ),
          const Divider(),
          ...items.map((e) => _button(context, e)),
        ],
      ),
    );
  }
}

class _Item {
  _Item({required this.name, this.page, this.tags = const []});

  final String name;

  final WidgetBuilder? page;

  final List<_Tag> tags;
}

class _Tag {
  const _Tag({required this.name, required this.color});

  final String name;

  final Color color;
}

class _TagView extends StatelessWidget {
  const _TagView(this.tag);

  final _Tag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tag.color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag.name,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
