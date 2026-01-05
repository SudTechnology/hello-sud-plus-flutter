import 'dart:convert';

class GameConfigModel {
  int gameMode;
  int gameCPU;
  int gameSoundControl;
  int gameSoundVolume;
  double viewScale;
  int autoScale;
  GameUi ui;

  GameConfigModel({this.gameMode = 1, this.gameCPU = 0, this.gameSoundControl = 0, this.gameSoundVolume = 100, this.viewScale = 1.0, this.autoScale = 0, GameUi? ui}) : ui = ui ?? GameUi();

  Map<String, dynamic> toJson() => {'gameMode': gameMode, 'gameCPU': gameCPU, 'gameSoundControl': gameSoundControl, 'gameSoundVolume': gameSoundVolume, 'viewScale': viewScale, 'autoScale': autoScale, 'ui': ui.toJson()};

  String toJsonString() => jsonEncode(toJson());
}

/* ================= UI ================= */

class GameUi {
  GameSettle gameSettle;
  GamePing ping;
  GameVersion version;
  GameLevel level;
  GameLobbySettingBtn lobby_setting_btn;
  GameLobbyHelpBtn lobby_help_btn;
  GameLobbyPlayers lobby_players;
  GameLobbyPlayerCaptainIcon lobby_player_captain_icon;
  GameLobbyPlayerKickoutIcon lobby_player_kickout_icon;
  GameLobbyRule lobby_rule;
  GameLobbyGameSetting lobby_game_setting;
  GameJoinBtn join_btn;
  GameCancelJoinBtn cancel_join_btn;
  GameReadyBtn ready_btn;
  GameCancelReadyBtn cancel_ready_btn;
  GameStartBtn start_btn;
  GameShareBtn share_btn;
  GameSttingBtn game_setting_btn;
  GameHelpBtn game_help_btn;
  GameSettleCloseBtn game_settle_close_btn;
  GameSettleAgainBtn game_settle_again_btn;
  GameBg game_bg;
  BlockChangeSeat block_change_seat;
  GameSettingSelectPnl game_setting_select_pnl;
  GameManagedImage game_managed_image;
  GameTableImage game_table_image;
  GameCountdownTime game_countdown_time;
  GameSelectedTips game_selected_tips;
  NFTAvatar nft_avatar;
  GameOpening game_opening;
  GameMvp game_mvp;
  UmoIcon umo_icon;
  Logo logo;
  GamePlayers game_players;
  BulletScreensBtn bullet_screens_btn;
  RoundOverPoopBtn round_over_poop_btn;
  RoundOverGoodBtn round_over_good_btn;
  Mask mask;
  WorstTeammateTip worst_teammate_tip;
  GameOverTip game_over_tip;
  LobbyAnimation lobby_animation;
  GameEffect game_effect;
  GameBurstSendBtn game_burst_send_btn;
  PlayerPairSignular player_pair_singular;
  GameRankInfo game_rank_info;
  Auxiliary auxiliary;
  ObPnl ob_pnl;

  GameUi({
    GameSettle? gameSettle,
    GamePing? ping,
    GameVersion? version,
    GameLevel? level,
    GameLobbySettingBtn? lobby_setting_btn,
    GameLobbyHelpBtn? lobby_help_btn,
    GameLobbyPlayers? lobby_players,
    GameLobbyPlayerCaptainIcon? lobby_player_captain_icon,
    GameLobbyPlayerKickoutIcon? lobby_player_kickout_icon,
    GameLobbyRule? lobby_rule,
    GameLobbyGameSetting? lobby_game_setting,
    GameJoinBtn? join_btn,
    GameCancelJoinBtn? cancel_join_btn,
    GameReadyBtn? ready_btn,
    GameCancelReadyBtn? cancel_ready_btn,
    GameStartBtn? start_btn,
    GameShareBtn? share_btn,
    GameSttingBtn? game_setting_btn,
    GameHelpBtn? game_help_btn,
    GameSettleCloseBtn? game_settle_close_btn,
    GameSettleAgainBtn? game_settle_again_btn,
    GameBg? game_bg,
    BlockChangeSeat? block_change_seat,
    GameSettingSelectPnl? game_setting_select_pnl,
    GameManagedImage? game_managed_image,
    GameTableImage? game_table_image,
    GameCountdownTime? game_countdown_time,
    GameSelectedTips? game_selected_tips,
    NFTAvatar? nft_avatar,
    GameOpening? game_opening,
    GameMvp? game_mvp,
    UmoIcon? umo_icon,
    Logo? logo,
    GamePlayers? game_players,
    BulletScreensBtn? bullet_screens_btn,
    RoundOverPoopBtn? round_over_poop_btn,
    RoundOverGoodBtn? round_over_good_btn,
    Mask? mask,
    WorstTeammateTip? worst_teammate_tip,
    GameOverTip? game_over_tip,
    LobbyAnimation? lobby_animation,
    GameEffect? game_effect,
    GameBurstSendBtn? game_burst_send_btn,
    PlayerPairSignular? player_pair_singular,
    GameRankInfo? game_rank_info,
    Auxiliary? auxiliary,
    ObPnl? ob_pnl,
  }) : gameSettle = gameSettle ?? GameSettle(),
       ping = ping ?? GamePing(),
       version = version ?? GameVersion(),
       level = level ?? GameLevel(),
       lobby_setting_btn = lobby_setting_btn ?? GameLobbySettingBtn(),
       lobby_help_btn = lobby_help_btn ?? GameLobbyHelpBtn(),
       lobby_players = lobby_players ?? GameLobbyPlayers(),
       lobby_player_captain_icon = lobby_player_captain_icon ?? GameLobbyPlayerCaptainIcon(),
       lobby_player_kickout_icon = lobby_player_kickout_icon ?? GameLobbyPlayerKickoutIcon(),
       lobby_rule = lobby_rule ?? GameLobbyRule(),
       lobby_game_setting = lobby_game_setting ?? GameLobbyGameSetting(),
       join_btn = join_btn ?? GameJoinBtn(),
       cancel_join_btn = cancel_join_btn ?? GameCancelJoinBtn(),
       ready_btn = ready_btn ?? GameReadyBtn(),
       cancel_ready_btn = cancel_ready_btn ?? GameCancelReadyBtn(),
       start_btn = start_btn ?? GameStartBtn(),
       share_btn = share_btn ?? GameShareBtn(),
       game_setting_btn = game_setting_btn ?? GameSttingBtn(),
       game_help_btn = game_help_btn ?? GameHelpBtn(),
       game_settle_close_btn = game_settle_close_btn ?? GameSettleCloseBtn(),
       game_settle_again_btn = game_settle_again_btn ?? GameSettleAgainBtn(),
       game_bg = game_bg ?? GameBg(),
       block_change_seat = block_change_seat ?? BlockChangeSeat(),
       game_setting_select_pnl = game_setting_select_pnl ?? GameSettingSelectPnl(),
       game_managed_image = game_managed_image ?? GameManagedImage(),
       game_table_image = game_table_image ?? GameTableImage(),
       game_countdown_time = game_countdown_time ?? GameCountdownTime(),
       game_selected_tips = game_selected_tips ?? GameSelectedTips(),
       nft_avatar = nft_avatar ?? NFTAvatar(),
       game_opening = game_opening ?? GameOpening(),
       game_mvp = game_mvp ?? GameMvp(),
       umo_icon = umo_icon ?? UmoIcon(),
       logo = logo ?? Logo(),
       game_players = game_players ?? GamePlayers(),
       bullet_screens_btn = bullet_screens_btn ?? BulletScreensBtn(),
       round_over_poop_btn = round_over_poop_btn ?? RoundOverPoopBtn(),
       round_over_good_btn = round_over_good_btn ?? RoundOverGoodBtn(),
       mask = mask ?? Mask(),
       worst_teammate_tip = worst_teammate_tip ?? WorstTeammateTip(),
       game_over_tip = game_over_tip ?? GameOverTip(),
       lobby_animation = lobby_animation ?? LobbyAnimation(),
       game_effect = game_effect ?? GameEffect(),
       game_burst_send_btn = game_burst_send_btn ?? GameBurstSendBtn(),
       player_pair_singular = player_pair_singular ?? PlayerPairSignular(),
       game_rank_info = game_rank_info ?? GameRankInfo(),
       auxiliary = auxiliary ?? Auxiliary(),
       ob_pnl = ob_pnl ?? ObPnl();

  Map<String, dynamic> toJson() => {
    'gameSettle': gameSettle.toJson(),
    'ping': ping.toJson(),
    'version': version.toJson(),
    'level': level.toJson(),
    'lobby_setting_btn': lobby_setting_btn.toJson(),
    'lobby_help_btn': lobby_help_btn.toJson(),
    'lobby_players': lobby_players.toJson(),
    'lobby_player_captain_icon': lobby_player_captain_icon.toJson(),
    'lobby_player_kickout_icon': lobby_player_kickout_icon.toJson(),
    'lobby_rule': lobby_rule.toJson(),
    'lobby_game_setting': lobby_game_setting.toJson(),
    'join_btn': join_btn.toJson(),
    'cancel_join_btn': cancel_join_btn.toJson(),
    'ready_btn': ready_btn.toJson(),
    'cancel_ready_btn': cancel_ready_btn.toJson(),
    'start_btn': start_btn.toJson(),
    'share_btn': share_btn.toJson(),
    'game_setting_btn': game_setting_btn.toJson(),
    'game_help_btn': game_help_btn.toJson(),
    'game_settle_close_btn': game_settle_close_btn.toJson(),
    'game_settle_again_btn': game_settle_again_btn.toJson(),
    'game_bg': game_bg.toJson(),
    'block_change_seat': block_change_seat.toJson(),
    'game_setting_select_pnl': game_setting_select_pnl.toJson(),
    'game_managed_image': game_managed_image.toJson(),
    'game_table_image': game_table_image.toJson(),
    'game_countdown_time': game_countdown_time.toJson(),
    'game_selected_tips': game_selected_tips.toJson(),
    'nft_avatar': nft_avatar.toJson(),
    'game_opening': game_opening.toJson(),
    'game_mvp': game_mvp.toJson(),
    'umo_icon': umo_icon.toJson(),
    'logo': logo.toJson(),
    'game_players': game_players.toJson(),
    'bullet_screens_btn': bullet_screens_btn.toJson(),
    'round_over_poop_btn': round_over_poop_btn.toJson(),
    'round_over_good_btn': round_over_good_btn.toJson(),
    'mask': mask.toJson(),
    'worst_teammate_tip': worst_teammate_tip.toJson(),
    'game_over_tip': game_over_tip.toJson(),
    'lobby_animation': lobby_animation.toJson(),
    'game_effect': game_effect.toJson(),
    'game_burst_send_btn': game_burst_send_btn.toJson(),
    'player_pair_singular': player_pair_singular.toJson(),
    'game_rank_info': game_rank_info.toJson(),
    'auxiliary': auxiliary.toJson(),
    'ob_pnl': ob_pnl.toJson(),
  };
}

/* ================= 基类 ================= */

class UiHide {
  bool hide;
  UiHide({this.hide = false});
  Map<String, dynamic> toJson() => {'hide': hide};
}

class UiCustomHide extends UiHide {
  bool custom;
  UiCustomHide({this.custom = false, bool hide = false}) : super(hide: hide);

  @override
  Map<String, dynamic> toJson() => {'custom': custom, 'hide': hide};
}

/* ================= 子项 ================= */

class GameSettle extends UiHide {}

class GamePing extends UiHide {}

class GameVersion extends UiHide {}

class GameLevel extends UiHide {}

class GameLobbySettingBtn extends UiHide {}

class GameLobbyHelpBtn extends UiHide {}

class GameLobbyPlayers extends UiCustomHide {}

class GameLobbyPlayerCaptainIcon extends UiHide {}

class GameLobbyPlayerKickoutIcon extends UiHide {}

class GameLobbyRule extends UiHide {}

class GameLobbyGameSetting extends UiHide {}

class GameJoinBtn extends UiCustomHide {}

class GameCancelJoinBtn extends UiCustomHide {}

class GameReadyBtn extends UiCustomHide {}

class GameCancelReadyBtn extends UiCustomHide {}

class GameStartBtn extends UiCustomHide {}

class GameShareBtn extends UiCustomHide {
  GameShareBtn() : super(hide: true);
}

class GameSttingBtn extends UiHide {}

class GameHelpBtn extends UiHide {}

class GameSettleCloseBtn extends UiCustomHide {}

class GameSettleAgainBtn extends UiCustomHide {}

class GameBg extends UiHide {}

class BlockChangeSeat extends UiCustomHide {}

class GameSettingSelectPnl extends UiHide {}

class GameManagedImage extends UiHide {}

class GameTableImage extends UiHide {}

class GameCountdownTime extends UiHide {}

class GameSelectedTips extends UiHide {}

class NFTAvatar extends UiHide {
  NFTAvatar() : super(hide: true);
}

class GameOpening extends UiHide {
  GameOpening() : super(hide: true);
}

class GameMvp extends UiHide {
  GameMvp() : super(hide: true);
}

class UmoIcon extends UiHide {}

class Logo extends UiHide {}

class GamePlayers extends UiHide {}

class BulletScreensBtn extends UiHide {
  BulletScreensBtn() : super(hide: true);
}

class RoundOverPoopBtn extends UiCustomHide {}

class RoundOverGoodBtn extends UiCustomHide {}

class Mask extends UiHide {}

class WorstTeammateTip extends UiHide {}

class GameOverTip extends UiHide {}

class LobbyAnimation extends UiHide {}

class GameEffect extends UiHide {}

class GameBurstSendBtn extends UiCustomHide {}

class PlayerPairSignular extends UiHide {}

class GameRankInfo extends UiHide {}

class Auxiliary extends UiHide {}

class ObPnl extends UiHide {}
