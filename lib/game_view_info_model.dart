import 'dart:convert';

/// 游戏 View 信息模型
class GameViewInfoModel {
  /// 返回码
  int retCode;

  /// 返回消息
  String retMsg;

  /// 游戏 View 的大小
  GameViewSizeModel viewSize;

  /// 游戏安全操作区域
  GameViewRectModel viewGameRect;

  GameViewInfoModel({this.retCode = 0, this.retMsg = 'success', GameViewSizeModel? viewSize, GameViewRectModel? viewGameRect}) : viewSize = viewSize ?? GameViewSizeModel(), viewGameRect = viewGameRect ?? GameViewRectModel();

  /// 转成 Map，用于 json.encode
  Map<String, dynamic> toJson() => {'ret_code': retCode, 'ret_msg': retMsg, 'view_size': viewSize.toJson(), 'view_game_rect': viewGameRect.toJson()};

  String toJsonString() => jsonEncode(toJson());
}

/// 游戏 View 尺寸
class GameViewSizeModel {
  /// 宽度（单位像素）
  int width;

  /// 高度（单位像素）
  int height;

  GameViewSizeModel({this.width = 0, this.height = 0});

  Map<String, dynamic> toJson() => {'width': width, 'height': height};
}

/// 游戏安全操作区域
class GameViewRectModel {
  int left;
  int top;
  int right;
  int bottom;

  GameViewRectModel({this.left = 0, this.top = 0, this.right = 0, this.bottom = 0});

  Map<String, dynamic> toJson() => {'left': left, 'top': top, 'right': right, 'bottom': bottom};
}
