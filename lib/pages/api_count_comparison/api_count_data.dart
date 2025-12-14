import 'dart:convert';
import 'package:flutter/services.dart';

/// API 數量比較數據
/// 
/// 此數據用於展示 Pigeon 的 API 數量與其他套件的對比
class ApiCountData {
  const ApiCountData({
    required this.packageName,
    required this.apiCount,
    required this.description,
    this.category,
  });

  final String packageName;
  final int apiCount;
  final String description;
  final String? category;

  factory ApiCountData.fromJson(Map<String, dynamic> json) {
    return ApiCountData(
      packageName: json['package_name'] as String? ?? '',
      apiCount: json['api_count'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String?,
    );
  }
}

/// Pigeon 的 API 統計
/// 
/// 根據官方文件統計（https://pub.dev/documentation/pigeon/latest/pigeon/）：
/// - Classes: 28 個
/// - Enums: 1 個（TaskQueueType）
/// - Constants: 3 個（async, attached, static）
/// 總計：32 個 API
const pigeonApiCount = 32; // 完整 API 數量（包含所有 Classes、Enums、Constants）

/// 從 assets 載入其他套件的 API 數量統計
Future<List<ApiCountData>> loadOtherPackagesApiCount() async {
  try {
    final jsonString = await rootBundle.loadString('assets/api_count_output.json');
    final jsonData = jsonDecode(jsonString) as List<dynamic>;
    
    return jsonData
        .map((item) => ApiCountData.fromJson(item as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('載入 API 數量數據失敗: $e');
    // 返回空列表或範例數據作為備用
    return [];
  }
}

/// 其他套件的 API 數量統計（範例數據，作為備用）
/// 
/// 實際數據從 assets/api_count_output.json 載入
const otherPackagesApiCountFallback = <ApiCountData>[];

/// 統計資訊
class ApiCountStatistics {
  const ApiCountStatistics({
    required this.totalPackages,
    required this.averageApiCount,
    required this.medianApiCount,
    required this.minApiCount,
    required this.maxApiCount,
    required this.pigeonRank,
  });

  final int totalPackages;
  final double averageApiCount;
  final double medianApiCount;
  final int minApiCount;
  final int maxApiCount;
  final int pigeonRank; // Pigeon 在排名中的位置（API 數量由少到多）

  static ApiCountStatistics calculate(List<ApiCountData> packages) {
    if (packages.isEmpty) {
      return const ApiCountStatistics(
        totalPackages: 0,
        averageApiCount: 0,
        medianApiCount: 0,
        minApiCount: 0,
        maxApiCount: 0,
        pigeonRank: 0,
      );
    }

    final sorted = List<ApiCountData>.from(packages)
      ..sort((a, b) => a.apiCount.compareTo(b.apiCount));

    final total = packages.length;
    final sum = packages.fold<int>(0, (sum, p) => sum + p.apiCount);
    final average = sum / total;
    final median = sorted[total ~/ 2].apiCount;
    final min = sorted.first.apiCount;
    final max = sorted.last.apiCount;

    // 計算 Pigeon 的排名（假設 Pigeon 的 API 數量）
    final pigeonRank = sorted.indexWhere((p) => p.apiCount >= pigeonApiCount);
    final rank = pigeonRank == -1 ? total : pigeonRank + 1;

    return ApiCountStatistics(
      totalPackages: total,
      averageApiCount: average,
      medianApiCount: median.toDouble(),
      minApiCount: min,
      maxApiCount: max,
      pigeonRank: rank,
    );
  }
}

