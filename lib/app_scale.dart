import 'package:flutter/foundation.dart';

/// Global UI scale for non-presentation pages (e.g. Menu/AutoTest/Demo).
/// Default 1.0. Adjust via SettingsPage.
final ValueNotifier<double> appScale = ValueNotifier<double>(1.0);

