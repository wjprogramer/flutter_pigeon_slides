流程:

前提:

- 不論是 pigeon or standard channels
    - 在一開始就要準備好兩個 IDE，flutter and android project
    - android project 初始化在 MainActivity.kt 並且要有 focus

##### Dart 端

- shift*2 / enter "pigeons"
- alt+ins / enter "dart" "message"
- enter below code:

  ```dart
  abstract class DeviceApi {
    DeviceInfo getDeviceInfo();
  }
  ```

  ```dart
  @HostApi()
  ```

  import pigeon

  ```dart
  class DeviceInfo {
    DeviceInfo({
      required this.androidVersion, 
      required this.model,
    });

    String androidVersion;
    String model;
  }
  ```

  enter

  ```dart
  @ConfigurePigeon(
    PigeonOptions(
      dartPackageName: 
    ),
  )
  ```

- 直接 alt + 1 跳到 Project View，打 `wjprogramer`，shift+"up", ctrl+C
- alt + 1 (back to editor)
- "Shift+Alt+Insert" 進入「列選取模式」(Column Selection)。
- shift + "up"，end, enter `.`
- Ctrl+Shift+J（Join Lines，快速合併多行）
- end, "back" remove last `.`
- "Shift+Alt+Insert" 離開「列選取模式」(Column Selection)。
- F2 (go to error point), copy/paste to param: `dartPackageName`
- enter and copy/paste package to "kotlinOptions: KotlinOptions(package: 'com.wjprogramer.flutter_pigeon_example.pigeons'),"
- enter "dartOut" "lib/pigeons/messages.dart",
- alt + 1, postion to "flutter_pigeon_example" folder
- ctrl + shift + C
- enter below code:

  ```
  kotlinOut: 'D:/projects/flutter_my/flutter_pigeon_example/android/app/src/main/kotlin/com/wjprogramer/flutter_pigeon_example',
  ```

  跳到字串內
  選取路徑字串 → Ctrl+W（反覆按會逐步擴展選取，直到整段字串）。

    - 按 Ctrl+R → 開啟 Replace in File。
    - 在 Find 輸入：\
    - 在 Replace 輸入：/
    - 按 Alt+A → Replace All。

    - ctrl+F
    - /android
    - alt + enter
    - 刪除前面

    - 最後補上 `/pigeons/Messages.kt`

- alt + f12 (terminal)
- enter: .\make_pigeons.bat

##### Android 端

- alt + tab 切專案 到 MainActivity

  ```kotlin
  private val deviceApiImpl = DeviceApiImpl()

  DeviceApi.setUp(messenger, deviceApiImpl)

  class DeviceApiImpl : DeviceApi {
      override fun getDeviceInfo(): DeviceInfo {
          val version = "${Build.VERSION.RELEASE} ${Build.VERSION.SDK_INT}"
          val model = Build.MODEL ?: "Unknown"
          return DeviceInfo(version, model)
      }
  }
  ```




