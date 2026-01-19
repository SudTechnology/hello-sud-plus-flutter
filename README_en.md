
# hello_sud_flutter

This demo demonstrates how to integrate the **SudGIP SDK**.

## sud_gip_plugin

Plugin link: [https://pub.dev/packages/sud_gip_plugin](https://pub.dev/packages/sud_gip_plugin)

The plugin encapsulates the interaction between the Flutter layer and the native layer.
On the native side, it uses the **game native SDK** to load games.

Currently supported platforms:

* **Android**
* **iOS**

Platform requirements:

* Android minimum SDK version: **22 (Android 5.1)**
* iOS minimum supported version: **11**

### Plugin Usage

Please refer to the demo code in:
`lib/game_page.dart`

### Modify the Native SDK Version
For Android, please refer to: `android/build.gradle.kts`<p>
For iOS, please refer to: `ios/Podfile`
