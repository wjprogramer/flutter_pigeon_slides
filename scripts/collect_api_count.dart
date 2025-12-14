/// 收集 pub.dev 上套件的 API 數量統計
/// 
/// 執行方式：
///   dart run scripts/collect_api_count.dart
/// 
/// 此腳本會：
/// 1. 從 pub.dev 獲取排名前 100 的套件
/// 2. 解析每個套件的 API 文件
/// 3. 統計 API 數量
/// 4. 輸出為 Dart 代碼格式，可直接複製到專案中

import 'dart:convert';
import 'dart:io';

class ApiCountBreakdown {
  ApiCountBreakdown({
    this.classes = 0,
    this.typedefs = 0,
    this.enums = 0,
    this.functions = 0,
    this.extensions = 0,
    this.mixins = 0,
  });

  final int classes;
  final int typedefs;
  final int enums;
  final int functions;
  final int extensions;
  final int mixins;

  int get total => classes + typedefs + enums + functions + extensions + mixins;

  Map<String, dynamic> toJson() => {
        'classes': classes,
        'typedefs': typedefs,
        'enums': enums,
        'functions': functions,
        'extensions': extensions,
        'mixins': mixins,
        'total': total,
      };
}

class PackageApiCount {
  PackageApiCount({
    required this.packageName,
    required this.apiCount,
    required this.description,
    this.category,
    this.pubDevUrl,
    this.breakdown,
  });

  final String packageName;
  final int apiCount;
  final String description;
  final String? category;
  final String? pubDevUrl;
  final ApiCountBreakdown? breakdown;

  Map<String, dynamic> toJson() => {
        'package_name': packageName,
        'api_count': apiCount,
        'description': description,
        if (category != null) 'category': category,
        if (pubDevUrl != null) 'pub_dev_url': pubDevUrl,
        if (breakdown != null) 'breakdown': breakdown!.toJson(),
      };

  String toDartCode() {
    final categoryStr = category != null ? "category: '$category'," : '';
    return '''  ApiCountData(
    packageName: '$packageName',
    apiCount: $apiCount,
    description: '${description.replaceAll("'", "\\'")}',
    $categoryStr
  ),''';
  }
}

Future<List<Map<String, dynamic>>> getTopPackages(int limit) async {
  print('正在獲取排名前 $limit 的套件...');

  // pub.dev API endpoint
  // 使用 packages API 來獲取熱門套件
  // 根據 pub.dev API 文檔，應該使用 /api/packages 端點
  final url = Uri.parse('https://pub.dev/api/packages')
      .replace(queryParameters: {
    'page': '1',
    'pageSize': limit.toString(),
  });

  try {
    print('請求 URL: $url');
    final client = HttpClient();
    final request = await client.getUrl(url);
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    print('HTTP 狀態碼: ${response.statusCode}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(responseBody) as Map<String, dynamic>;
        
        // 調試：打印響應結構的前幾個項目
        print('API 響應結構預覽:');
        print('  響應鍵: ${data.keys.toList()}');
        
        if (data.containsKey('packages')) {
          final packages = data['packages'] as List<dynamic>?;
          if (packages != null && packages.isNotEmpty) {
            print('  找到 ${packages.length} 個套件');
            print('  第一個套件結構: ${packages[0]}');
          }
        }
        if (data.containsKey('results')) {
          final results = data['results'] as List<dynamic>?;
          if (results != null && results.isNotEmpty) {
            print('  找到 ${results.length} 個結果');
            print('  第一個結果結構: ${results[0]}');
          }
        }
        
        // 嘗試不同的響應結構
        List<dynamic>? packagesList;
        if (data.containsKey('packages')) {
          packagesList = data['packages'] as List<dynamic>?;
        } else if (data.containsKey('results')) {
          packagesList = data['results'] as List<dynamic>?;
        }
        
        if (packagesList != null) {
          // 限制數量
          final limited = packagesList.take(limit).toList();
          print('成功解析 ${limited.length} 個套件');
          return limited.cast<Map<String, dynamic>>();
        }
        
        print('警告: 無法找到套件列表，響應結構: ${data.keys.toList()}');
        return [];
      } catch (e) {
        print('解析 JSON 失敗: $e');
        print('響應內容前 500 字元: ${responseBody.substring(0, responseBody.length > 500 ? 500 : responseBody.length)}');
        return [];
      }
    } else {
      print('獲取套件列表失敗: HTTP ${response.statusCode}');
      print('響應內容前 500 字元: ${responseBody.substring(0, responseBody.length > 500 ? 500 : responseBody.length)}');
      return [];
    }
  } catch (e, stackTrace) {
    print('獲取套件列表失敗: $e');
    print('堆疊追蹤: $stackTrace');
    return [];
  }
}

Future<ApiCountBreakdown?> countApisFromDocumentation(String packageName) async {
  // pub.dev 的 API 文件格式：
  // https://pub.dev/documentation/{package_name}/latest/
  
  if (packageName.isEmpty) {
    print('  錯誤: 套件名稱為空');
    return null;
  }

  final docUrl = Uri.parse(
    'https://pub.dev/documentation/$packageName/latest/',
  );

  try {
    final client = HttpClient();
    final request = await client.getUrl(docUrl);
    final response = await request.close();

    if (response.statusCode != 200) {
      print('  錯誤: HTTP ${response.statusCode}');
      return null;
    }

    final responseBody = await response.transform(utf8.decoder).join();
    final content = responseBody;

    // 解析 HTML 來找到分類的 API
    // pub.dev 的 API 文件頁面通常有分類標題，例如：
    // - "Classes" 或 "class"
    // - "Typedefs" 或 "typedef"
    // - "Enums" 或 "enum"
    // - "Functions" 或 "function"
    // - "Extensions" 或 "extension"
    // - "Mixins" 或 "mixin"

    // 方法 1: 查找分類標題後的列表項
    var classesCount = 0;
    var typedefsCount = 0;
    var enumsCount = 0;
    var functionsCount = 0;
    var extensionsCount = 0;
    var mixinsCount = 0;

    // 查找 Classes
    final classPattern = RegExp(
      r'<h[23][^>]*>.*?(?:Classes?|class)[^<]*</h[23]>',
      caseSensitive: false,
    );
    if (classPattern.hasMatch(content)) {
      // 找到分類標題後，查找該分類下的項目
      final classSectionPattern = RegExp(
        r'<h[23][^>]*>.*?(?:Classes?|class)[^<]*</h[23]>.*?(?=<h[23]|$)',
        caseSensitive: false,
        dotAll: true,
      );
      final match = classSectionPattern.firstMatch(content);
      if (match != null) {
        final section = match.group(0) ?? '';
        // 統計該分類下的 <li> 或 <a> 標籤
        classesCount = RegExp(r'<li[^>]*>|<a[^>]*class="[^"]*api[^"]*"[^>]*>',
                caseSensitive: false)
            .allMatches(section)
            .length;
      }
    }

    // 方法 2: 直接統計 HTML 中的 API 連結模式
    // pub.dev 的 API 文件通常使用特定的 class 名稱
    final apiLinkPattern = RegExp(
      r'<a[^>]*href="[^"]*api[^"]*"[^>]*>',
      caseSensitive: false,
    );
    final apiLinks = apiLinkPattern.allMatches(content).length;

    // 方法 3: 統計特定的 HTML 結構
    // 查找包含 "class"、"typedef"、"enum" 等關鍵字的連結
    final classLinks = RegExp(
      r'<a[^>]*href="[^"]*class[^"]*"[^>]*>|<a[^>]*>.*?class[^<]*</a>',
      caseSensitive: false,
    ).allMatches(content).length;

    final typedefLinks = RegExp(
      r'<a[^>]*href="[^"]*typedef[^"]*"[^>]*>|<a[^>]*>.*?typedef[^<]*</a>',
      caseSensitive: false,
    ).allMatches(content).length;

    final enumLinks = RegExp(
      r'<a[^>]*href="[^"]*enum[^"]*"[^>]*>|<a[^>]*>.*?enum[^<]*</a>',
      caseSensitive: false,
    ).allMatches(content).length;

    // 如果找到分類數據，使用分類數據；否則使用總計
    if (apiLinks > 0 || classLinks > 0) {
      return ApiCountBreakdown(
        classes: classLinks > 0 ? classLinks : (apiLinks ~/ 3),
        typedefs: typedefLinks > 0 ? typedefLinks : 0,
        enums: enumLinks > 0 ? enumLinks : 0,
        functions: apiLinks > (classLinks + typedefLinks + enumLinks)
            ? apiLinks - (classLinks + typedefLinks + enumLinks)
            : 0,
        extensions: extensionsCount,
        mixins: mixinsCount,
      );
    }

    // 如果以上方法都失敗，嘗試簡單的關鍵字匹配
    final contentLower = content.toLowerCase();
    final simpleCount = ApiCountBreakdown(
      classes: classesCount > 0
          ? classesCount
          : RegExp(r'\bclass\s+\w+').allMatches(contentLower).length,
      typedefs: typedefsCount > 0
          ? typedefsCount
          : RegExp(r'\btypedef\s+').allMatches(contentLower).length,
      enums: enumsCount > 0
          ? enumsCount
          : RegExp(r'\benum\s+\w+').allMatches(contentLower).length,
      functions: functionsCount > 0
          ? functionsCount
          : RegExp(r'\bfunction\s+\w+|\b\w+\s*\([^)]*\)\s*\{')
              .allMatches(contentLower)
              .length,
      extensions: extensionsCount > 0
          ? extensionsCount
          : RegExp(r'\bextension\s+\w+').allMatches(contentLower).length,
      mixins: mixinsCount > 0
          ? mixinsCount
          : RegExp(r'\bmixin\s+\w+').allMatches(contentLower).length,
    );

    return simpleCount.total > 0 ? simpleCount : null;
  } catch (e) {
    print('  解析 $packageName 的 API 文件失敗: $e');
    return null;
  }
}

Future<List<PackageApiCount>> collectApiCounts(
  List<Map<String, dynamic>> packages,
  int limit,
) async {
  final results = <PackageApiCount>[];

  for (var i = 0; i < packages.length && i < limit; i++) {
    final package = packages[i];
    
    // 嘗試不同的欄位名稱來獲取套件名稱
    final packageName = (package['package'] as String?) ??
        (package['name'] as String?) ??
        '';
    final description = (package['description'] as String?) ??
        (package['shortDescription'] as String?) ??
        '';

    // 檢查套件名稱
    if (packageName.isEmpty) {
      print('[${i + 1}/$limit] ⚠️  跳過: 套件名稱為空');
      print('  套件數據鍵: ${package.keys.toList()}');
      print('  套件數據: $package');
      continue;
    }

    print('[${i + 1}/$limit] 正在處理: $packageName');
    print('  文件連結: https://pub.dev/documentation/$packageName/latest/');

    final breakdown = await countApisFromDocumentation(packageName);

    if (breakdown != null && breakdown.total > 0) {
      results.add(PackageApiCount(
        packageName: packageName,
        apiCount: breakdown.total,
        description: description,
        pubDevUrl: 'https://pub.dev/packages/$packageName',
        breakdown: breakdown,
      ));
      print('  ✓ API 總數: ${breakdown.total}');
      print('    - Classes: ${breakdown.classes}');
      print('    - Typedefs: ${breakdown.typedefs}');
      print('    - Enums: ${breakdown.enums}');
      print('    - Functions: ${breakdown.functions}');
      if (breakdown.extensions > 0) {
        print('    - Extensions: ${breakdown.extensions}');
      }
      if (breakdown.mixins > 0) {
        print('    - Mixins: ${breakdown.mixins}');
      }
    } else {
      print('  ✗ 無法獲取 API 數量');
    }

    // 避免請求過於頻繁
    await Future.delayed(const Duration(milliseconds: 500));
  }

  return results;
}

String generateDartCode(List<PackageApiCount> data) {
  final buffer = StringBuffer();
  buffer.writeln('/// 其他套件的 API 數量統計（從 pub.dev 收集）');
  buffer.writeln('const otherPackagesApiCount = <ApiCountData>[');
  
  for (final item in data) {
    buffer.writeln(item.toDartCode());
  }
  
  buffer.writeln('];');
  return buffer.toString();
}

String generateJson(List<PackageApiCount> data) {
  final jsonData = data.map((item) => item.toJson()).toList();
  return const JsonEncoder.withIndent('  ').convert(jsonData);
}

void printStatistics(List<PackageApiCount> results) {
  if (results.isEmpty) {
    print('\n沒有收集到任何數據');
    return;
  }

  final apiCounts = results.map((r) => r.apiCount).toList()..sort();
  final average = apiCounts.reduce((a, b) => a + b) / apiCounts.length;
  final median = apiCounts[apiCounts.length ~/ 2];
  final min = apiCounts.first;
  final max = apiCounts.last;

  print('\n統計資訊:');
  print('  總套件數: ${results.length}');
  print('  平均 API 數量: ${average.toStringAsFixed(1)}');
  print('  中位數: $median');
  print('  最小 API 數量: $min');
  print('  最大 API 數量: $max');
}

Future<void> main() async {
  print('=' * 60);
  print('Pub.dev API 數量收集工具');
  print('=' * 60);

  // 獲取排名前 100 的套件
  final packages = await getTopPackages(100);

  if (packages.isEmpty) {
    print('無法獲取套件列表，請檢查網路連線');
    exit(1);
  }

  print('\n成功獲取 ${packages.length} 個套件\n');

  // 收集 API 數量
  final results = await collectApiCounts(packages, 100);

  if (results.isEmpty) {
    print('\n沒有成功收集到任何數據');
    exit(1);
  }

  // 輸出統計資訊
  printStatistics(results);

  // 生成 Dart 代碼
  print('\n' + '=' * 60);
  print('Dart 代碼（可直接複製到 api_count_data.dart）:');
  print('=' * 60);
  print(generateDartCode(results));

  // 生成 JSON（備用）
  print('\n' + '=' * 60);
  print('JSON 格式（備用）:');
  print('=' * 60);
  print(generateJson(results));

  // 保存到文件
  final dartFile = File('scripts/api_count_output.dart');
  await dartFile.writeAsString(generateDartCode(results));
  print('\n✓ Dart 代碼已保存到: ${dartFile.path}');

  final jsonFile = File('scripts/api_count_output.json');
  await jsonFile.writeAsString(generateJson(results));
  print('✓ JSON 數據已保存到: ${jsonFile.path}');
}

