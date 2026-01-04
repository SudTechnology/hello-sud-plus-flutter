import 'package:flutter/material.dart';
import 'package:sud_gip_plugin/sud_gip_plugin.dart';
import 'package:hello_sud_flutter/game_config_model.dart';
import 'package:hello_sud_flutter/game_view_info_model.dart';
import 'package:hello_sud_flutter/game_utils.dart';
import 'dart:convert';
import 'dart:typed_data';

class GamePage extends StatefulWidget {
  final String userId;
  final String roomId;
  final String gameId;

  const GamePage({super.key, required this.userId, required this.roomId, required this.gameId});

  @override
  State<StatefulWidget> createState() => GamePageState();
}

/// 这是demo演示所使用的appId和appKey，开发者接入自己app需要将其替换为在我们平台申请的appId和appKey
/// These are the appId and appKey used in the demo. Developers need to replace them with the appId and appKey they applied for on our platform when integrating their own apps.
const String SUD_APP_ID = '1461564080052506636';
const String SUD_APP_KEY = '03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc';

class GamePageState extends State<GamePage> with WidgetsBindingObserver {
  final GlobalKey _gameViewKey = GlobalKey();
  Size? _viewSize; // Flutter 逻辑像素  English:Logical pixels
  Size? _physicalSize; // 屏幕物理像素 English:Screen physical pixels
  double? _devicePixelRatio;
  Widget? _gameView;
  int? _platformViewId;

  /// 这里的userId、roomId、gameId、language都由开发者自身定义
  /// The userId, roomId, gameId, and language here are all defined by the developer.
  String? _userId;
  String? _roomId;
  String? _gameId;
  final String _language = I18n.getBCP47Language();
  late final SudGIPFSMGameDelegate _fsmGame;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _roomId = widget.roomId;
    _gameId = widget.gameId;

    // 初始化游戏回调
    // Initialize game callback
    initSudGIPFsmGame();

    // create PlatformView
    _gameView = getSudGIPPlatformView((int viewId) {
      log('platformView已经创建好了：$viewId');
      _platformViewId = viewId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateViewSize();
      });
      // 这里注意了，等PlatformView创建好之后，才能去加载游戏
      // Note that the game can only be loaded after the PlatformView has been created.
      switchGame();
    });

    // getVersion
    SudGipPlugin.getVersion().then((String? version) {
      log('gip version = $version');
    });

    // regist observer
    WidgetsBinding.instance.addObserver(this);
  }

  /// 游戏回调给app的消息
  /// Game callback messages to the app
  void initSudGIPFsmGame() {
    _fsmGame = SudGIPFSMGameDelegate(
      onGameLoadingProgress: (stage, retCode, progress) {
        log('onGameLoadingProgress stage: $stage retCode: $retCode progress: $progress');
        // 这个是调用switchGame之后，游戏的加载进度回调
        // This is the game loading progress callback after calling switchGame.
      },
      onGameStarted: () {
        log('onGameStarted');
        // 这个回调表示游戏已经加载完成了
        // This callback indicates that the game has finished loading.
      },
      onGameDestroyed: () {
        log('onGameDestroyed');
        // 这个回调表示游戏销毁了
        // This callback indicates that the game has been destroyed.
      },
      onExpireCode: (dataJson) {
        log('onExpireCodeCallback dataJson:$dataJson');
        processOnExpireCode();
        // 这个回调表示code过期了，按照本demo示例代码进行处理
        // This callback indicates that the code has expired; please handle it according to the code example in this demo.
      },
      onGameStateChange: (state, dataJson) {
        log('onGameStateChange state: $state dataJson:$dataJson');
        // 这个是游戏发送过来的游戏状态，对应协议文档为：https://docs.sud.tech/zh-CN/app/Client/MGFSM/CommonStateGame.html
        // This is the game status sent by the game; the corresponding protocol document is:https://docs.sud.tech/en-US/app/Client/MGFSM/CommonStateGame.html
      },
      onPlayerStateChange: (userId, state, dataJson) {
        log('onPlayerStateChange userId:$userId state: $state dataJson:$dataJson');
        // 这个是游戏发送过来的玩家状态，对应协议文档为：https://docs.sud.tech/zh-CN/app/Client/MGFSM/CommonStatePlayer.html
        // This is the player status sent by the game; the corresponding protocol document is:https://docs.sud.tech/en-US/app/Client/MGFSM/CommonStatePlayer.html
      },
    );
  }

  /// 给游戏的code过期了，从后端拿一个新的code值，然后发送给游戏
  /// The game's code has expired. Retrieve a new code value from the backend and send it to the game.
  void processOnExpireCode() async {
    int? viewId = _platformViewId;
    if (viewId == null) {
      log("error platformViewId can not empty");
      return;
    }
    var code = await getCode();
    if (code == null || code.isEmpty) {
      log('error:code can not be empty');
      return;
    }
    SudGipPlugin.updateCode(viewId, code);
  }

  void updateViewSize() {
    final renderBox = _gameViewKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      _devicePixelRatio = devicePixelRatio;
      _viewSize = size;
      _physicalSize = Size(size.width * devicePixelRatio, size.height * devicePixelRatio);

      log('Flutter 逻辑像素: ${size.width} x ${size.height}, 物理像素: ${_physicalSize!.width} x ${_physicalSize!.height}');
    }
  }

  /// 开始加载游戏
  /// Start loading the game
  void switchGame() async {
    // initSDK
    var result = await SudGipPlugin.initSDK(SUD_APP_ID, SUD_APP_KEY, _userId!);
    log('initSDK retCode：${result['retCode']} retMsg:${result['retMsg']}');
    if (result['retCode'] != 0) {
      log('initSDK error retCode：${result['retCode']} retMsg:${result['retMsg']}');
      return;
    }

    // getCode
    String? code = await getCode();
    if (code == null || code.isEmpty) {
      log('error:code can not be empty');
      return;
    }

    int? viewId = _platformViewId;
    if (viewId == null) {
      log("error platformViewId can not empty");
      return;
    }

    // setCallback
    SudGipPlugin.setFSMGame(viewId, _fsmGame);

    // loadGame，如果loadGameResult['retCode']返回的值不为0，则通常表示flutter层传入的参数有误，请注意不要传空值
    // If loadGameResult['retCode'] returns a non-zero value, it usually indicates that the parameter passed to the Flutter layer is incorrect. Please be careful not to pass an empty value.
    var loadGameResult = await SudGipPlugin.loadGame(viewId, _userId!, _roomId!, code, _gameId!, _language, getGameViewInfo(), getGameConfig());
    log('loadGameResult retCode:${loadGameResult['retCode']} retMsg:${loadGameResult['retMsg']}');
  }

  Future<String?> getCode() async {
    // 注意！！！ 这个是demo用的接口，开发者用了自己的appId之后，调用自己后端接口，让后端返回code值给客户端
    // Attention!!! This is an API for demo use. Developers use their own appId to call their own backend API, which then returns a code value to the client.
    var resp = await postRequest('https://prod-hellosud-base.s00.tech', '/login/v3', {'user_id': widget.userId, 'app_id': SUD_APP_ID});
    if (resp['ret_code'] == 0) {
      return resp['data']['code'];
    }
    return null;
  }

  String getGameViewInfo() {
    // 这个宽和高，用的是PlatformView的实际像素，值正确的情况下，不用修改
    // The width and height are based on the actual pixels of the PlatformView; if the values ​​are correct, no modification is needed.
    int width = _physicalSize!.width.ceil();
    int height = _physicalSize!.height.ceil();

    // 这个top和bottom，相当于PlatformView，也就是游戏View的padding值，也是像素为单位，开发者根据自身页面布局设置
    // The `top` and `bottom` values ​​are equivalent to the `padding` values ​​of the `PlatformView`, which is the game view. These values ​​are also measured in pixels and are set by the developer based on their page layout.
    final int top = (_devicePixelRatio! * 60).ceil(); // paddingTop
    final int bottom = (_devicePixelRatio! * 130).ceil(); // paddingBottom

    final model = GameViewInfoModel(
      viewSize: GameViewSizeModel(width: width, height: height), //
      viewGameRect: GameViewRectModel(left: 0, top: top, right: 0, bottom: bottom),
    );

    final jsonStr = model.toJsonString();
    log(jsonStr);
    return jsonStr;
  }

  String getGameConfig() {
    final config = GameConfigModel();

    config.ui.ping.hide = false; // 配置不隐藏ping值 English: Configuration to not hide ping value

    final jsonStr = config.toJsonString();
    log(jsonStr);
    return jsonStr;
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(fixedSize: const Size(150, 60), backgroundColor: Color.fromARGB(255, 17, 122, 111).withOpacity(0.6));
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) return;
        // 提前销毁游戏，或者在dispose当中销毁游戏都可以
        // destroyGame();
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Game View Container
            Container(
              key: _gameViewKey,
              color: Colors.blue, // Background color for gameView
              child: _gameView,
            ),
            // Operation Page Container
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: const Color(0x00000000), // Background color for the operation container
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20), // Space above the buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Load Game action
                            switchGame();
                          },
                          child: Text('Load Game'),
                        ),
                        SizedBox(width: 20), // Space between the buttons
                        ElevatedButton(
                          onPressed: () {
                            // Destroy Game action
                            destroyGame();
                          },
                          child: Text('Destroy Game'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // Space below the buttons
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void destroyGame() {
    int? viewId = _platformViewId;
    if (viewId != null) {
      testMethod(viewId);

      SudGipPlugin.removeFSMGame(viewId);
      SudGipPlugin.destroyGame(viewId);
    }
  }

  void testMethod(int viewId) async {
    // var result = await SudGipPlugin.pushAudio(viewId, Uint8List.fromList([0x0a, 0x01, 0x02, 0x03, 0x04, 0x05]));
    // log('pushAudio retCode：${result['retCode']} retMsg:${result['retMsg']}');
    // SudGipCfgPlugin.putAdvancedConfig({'testKey': 'testValue'});
  }

  void log(String msg) {
    print(msg);
  }

  @override
  void dispose() {
    // remove observer
    WidgetsBinding.instance.removeObserver(this);
    // destroyGame
    destroyGame();

    // PlatformView不再使用时，通知原生端释放资源；注意调用之后，不要再使用此id的PlatformView
    // When PlatformView is no longer in use, notify the native application to release resources; note that after this call, do not reuse the PlatformView with this ID.
    int? viewId = _platformViewId;
    if (viewId != null) {
      SudGipPlugin.dispose(viewId);
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        log("Lifecycle 应用回到前台");
        int? viewId = _platformViewId;
        if (viewId != null) {
          SudGipPlugin.playGame(viewId);
        }
        break;
      case AppLifecycleState.inactive:
        log("Lifecycle 应用处于非活动状态（过渡状态）");
        break;
      case AppLifecycleState.paused:
        log("Lifecycle 应用进入后台");
        int? viewId = _platformViewId;
        if (viewId != null) {
          SudGipPlugin.pauseGame(viewId);
        }
        break;
      case AppLifecycleState.detached:
        log("Lifecycle 应用被销毁，Flutter 引擎仍然挂载");
        break;
      case AppLifecycleState.hidden:
        log("Lifecycle 应用被隐藏");
        break;
    }
  }

  /// 此方法演示如何给游戏发送消息，前提是游戏已经运行起来了，在onGameStarted和destroyGame之间发送才有效
  /// This method demonstrates how to send messages to the game, provided the game is already running. Sending messages between `onGameStarted` and `destroyGame` is required for the message to work.
  void notifyStateChange() {
    int? viewId = _platformViewId;
    if (viewId == null) {
      // 发送消息给游戏是有PlatformView的id绑定的
      // Sending messages to the game is bound to the PlatformView's ID.
      return;
    }

    /// 需要发送什么消息，就根据制定的协议，去修改对应的state和dataJson就可以了，协议文档链接：https://docs.sud.tech/zh-CN/app/Client/APPFST/CommonState.html
    /// To send a specific message, simply modify the corresponding state and dataJson according to the defined protocol. Protocol documentation link:https://docs.sud.tech/en-US/app/Client/APPFST/CommonState.html
    String state = "app_common_self_in";
    String dataJson = jsonEncode({'isIn': true, 'seatIndex': -1, 'isRandom': true, 'teamId': 1});
    SudGipPlugin.notifyStateChange(viewId, state, dataJson);
  }
}
