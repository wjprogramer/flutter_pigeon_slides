/// 全局保存自動測試結果，避免離開頁面後結果消失
class AutoTestResults {
  static final AutoTestResults _instance = AutoTestResults._internal();
  factory AutoTestResults() => _instance;
  AutoTestResults._internal();

  // Flutter → Native 結果
  final List<double> mcSeries = [];
  final List<double> mcLongSeries = [];
  final List<double> pigeonSeries = [];
  final List<double> basicSeries = [];
  final List<double> ffiSeries = [];
  final List<double> dartSeries = [];
  
  double mcTotalMs = 0;
  double mcLongTotalMs = 0;
  double pigeonTotalMs = 0;
  double basicTotalMs = 0;
  double ffiTotalMs = 0;
  double dartTotalMs = 0;

  // Native → Flutter 結果
  final List<double> m2fMethodSeries = [];
  final List<double> m2fPigeonEventSeries = [];
  final List<double> m2fPigeonFlutterSeries = [];

  /// 清除所有結果
  void clear() {
    mcSeries.clear();
    mcLongSeries.clear();
    pigeonSeries.clear();
    basicSeries.clear();
    ffiSeries.clear();
    dartSeries.clear();
    m2fMethodSeries.clear();
    m2fPigeonEventSeries.clear();
    m2fPigeonFlutterSeries.clear();
    mcTotalMs = 0;
    mcLongTotalMs = 0;
    pigeonTotalMs = 0;
    basicTotalMs = 0;
    ffiTotalMs = 0;
    dartTotalMs = 0;
  }

  /// 更新 Flutter → Native 結果
  void updateFlutterToNative({
    required List<double> mc,
    required List<double> mcLong,
    required List<double> pigeon,
    required List<double> basic,
    required List<double> ffi,
    required List<double> dart,
    required double mcTotal,
    required double mcLongTotal,
    required double pigeonTotal,
    required double basicTotal,
    required double ffiTotal,
    required double dartTotal,
  }) {
    mcSeries.clear();
    mcSeries.addAll(mc);
    mcLongSeries.clear();
    mcLongSeries.addAll(mcLong);
    pigeonSeries.clear();
    pigeonSeries.addAll(pigeon);
    basicSeries.clear();
    basicSeries.addAll(basic);
    ffiSeries.clear();
    ffiSeries.addAll(ffi);
    dartSeries.clear();
    dartSeries.addAll(dart);
    
    mcTotalMs = mcTotal;
    mcLongTotalMs = mcLongTotal;
    pigeonTotalMs = pigeonTotal;
    basicTotalMs = basicTotal;
    ffiTotalMs = ffiTotal;
    dartTotalMs = dartTotal;
  }

  /// 更新 Native → Flutter 結果
  void updateNativeToFlutter({
    required List<double> method,
    required List<double> pigeonEvent,
    required List<double> pigeonFlutter,
  }) {
    m2fMethodSeries.clear();
    m2fMethodSeries.addAll(method);
    m2fPigeonEventSeries.clear();
    m2fPigeonEventSeries.addAll(pigeonEvent);
    m2fPigeonFlutterSeries.clear();
    m2fPigeonFlutterSeries.addAll(pigeonFlutter);
  }
}

