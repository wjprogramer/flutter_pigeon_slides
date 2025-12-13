import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/pages/api_doc/api_doc_page.dart';
import 'package:flutter_pigeon_slides/pages/analysis_aspects/analysis_aspects_page.dart';
import 'package:flutter_pigeon_slides/pages/auto_test/auto_test_page.dart';
import 'package:flutter_pigeon_slides/pages/demo/demo_page.dart';
import 'package:flutter_pigeon_slides/pages/readable/readable_page.dart';
import 'package:flutter_pigeon_slides/pages/settings/settings_page.dart';
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
    _Item(
      name: '分析面向',
      page: (_) => const AnalysisAspectsPage(),
      tags: [const _Tag(name: '入口', color: Colors.blue)],
    ),
    _Item(
      name: 'Auto Perf Runner',
      page: (_) => const AutoTestPage(),
      tags: [const _Tag(name: 'auto', color: Colors.orange)],
    ),
    _Item(
      name: 'Demo / Perf',
      page: (_) => DemoPage(),
      tags: [const _Tag(name: 'new', color: Colors.green)],
    ),
    _Item(name: '可讀性 Readable', page: (_) => ReadablePage()),
    _Item(name: 'pigeon 文件 API Doc', page: (_) => ApiDocPage()),
    ...qaSections.map(
      (s) => _Item(
        name: s.title,
        page: (_) => QaSectionPage(section: s),
      ),
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
