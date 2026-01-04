import 'dart:convert';
import 'dart:io';
import 'dart:ui';

Future<Map<String, dynamic>> postRequest(String url, String api, Map<String, dynamic> jsonMap) async {
  HttpClient httpClient = HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url + api));
  request.headers.set('Content-Type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  Map<String, dynamic> map = json.decode(reply);
  return map;
}

class I18n {
  static final Map<String, Map<String, String>> _localizedValues = {
    // English
    'default': {
      'room_id_title': 'Using the same roomId allows multiple users to play together', //
      'welcome': 'Welcome, {name}!',
      'click_game_info': 'Click on one of the games below to enter the game page',
      'game_bumper': 'Bumper Blaster',
      'game_dart_master': 'Dart Master',
    },
    // 下面是中文
    'zh': {
      'room_id_title': '使用同一个roomId可以让多个用户共同游戏', //
      'welcome': '欢迎, {name}!',
      'click_game_info': '点击下方的其中一个游戏，可进入游戏页面',
      'game_bumper': '碰碰我最强',
      'game_dart_master': '飞镖达人',
    },
  };
  static String currentLang = PlatformDispatcher.instance.locale.languageCode;

  // 参数方式的使用：Text(I18n.t('welcome', params: {'name': 'Dan'}))
  static String t(String key, {Map<String, String>? params}) {
    var map = _localizedValues[currentLang] ?? _localizedValues['default'];
    String? value = map?[key] ?? key;
    params?.forEach((k, v) {
      value = value!.replaceAll('{$k}', v);
    });
    return value!;
  }

  // example:en-US、zh-CN
  static String getBCP47Language() {
    Locale locale = PlatformDispatcher.instance.locale;
    if (locale.countryCode?.isNotEmpty == true) {
      return '${locale.languageCode}-${locale.countryCode}';
    }
    return locale.languageCode;
  }
}
