import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/pages/auto_test/auto_test_page.dart';
import 'package:flutter_pigeon_slides/pages/readable/readable_page.dart';

/// 分析面向的數據模型
class AnalysisAspect {
  const AnalysisAspect({
    required this.name,
    required this.description,
    this.pageBuilder,
    this.icon,
    this.color,
  });

  /// 面向名稱
  final String name;

  /// 描述
  final String description;

  /// 對應的頁面構建器（可選）
  final WidgetBuilder? pageBuilder;

  /// 圖標（可選）
  final IconData? icon;

  /// 顏色（可選）
  final Color? color;
}

/// 所有分析面向的列表
final analysisAspects = <AnalysisAspect>[
  AnalysisAspect(
    name: '效能',
    description: '效能測試與對比實驗',
    pageBuilder: (_) => const AutoTestPage(),
    icon: Icons.speed,
    color: Colors.orange,
  ),
  AnalysisAspect(
    name: '可讀性',
    description: '程式碼可讀性對比',
    pageBuilder: (_) => ReadablePage(),
    icon: Icons.article,
    color: Colors.blue,
  ),
  AnalysisAspect(
    name: '測試',
    description: '測試相關的討論與實作',
    pageBuilder: null, // TODO: 待實作
    icon: Icons.bug_report,
    color: Colors.green,
  ),
  AnalysisAspect(
    name: '學習曲線',
    description: '學習成本與上手難度',
    pageBuilder: null, // TODO: 待實作
    icon: Icons.trending_up,
    color: Colors.purple,
  ),
  AnalysisAspect(
    name: '可維護性',
    description: '長期維護與演進的考量',
    pageBuilder: null, // TODO: 待實作
    icon: Icons.build,
    color: Colors.teal,
  ),
  AnalysisAspect(
    name: '活躍度',
    description: '套件更新頻率與社群活躍度',
    pageBuilder: null, // TODO: 待實作
    icon: Icons.update,
    color: Colors.indigo,
  ),
  AnalysisAspect(
    name: '公信力',
    description: '官方維護與社群信任度',
    pageBuilder: null, // TODO: 待實作
    icon: Icons.verified,
    color: Colors.cyan,
  ),
  AnalysisAspect(
    name: '開發速度',
    description: '開發效率與時間成本',
    pageBuilder: null, // TODO: 待實作
    icon: Icons.timer,
    color: Colors.red,
  ),
];

