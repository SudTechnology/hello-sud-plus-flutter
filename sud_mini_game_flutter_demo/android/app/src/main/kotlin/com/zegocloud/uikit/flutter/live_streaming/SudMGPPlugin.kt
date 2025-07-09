package com.zegocloud.uikit.flutter.live_streaming

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.platform.PlatformView
import tech.sud.mgp.core.ISudFSMMG
import tech.sud.mgp.core.ISudFSMStateHandle
import tech.sud.mgp.core.ISudFSTAPP
import tech.sud.mgp.core.ISudListenerGetMGList
import tech.sud.mgp.core.ISudListenerInitSDK
import tech.sud.mgp.core.SudMGP


class SudMGPPlugin : MethodCallHandler, PlatformView {

    private var uiHandler: Handler? = null
    private var context: Context
    private var activity: Activity? = null
    private var methodChannel: MethodChannel

    private var _gameApp: ISudFSTAPP? = null // game interface
    private var _gameView: View? = null
    private val gameContainer: FrameLayout

    private var _viewSize: String? = null
    private var _gameConfig: String? = null
    private val eventSinkHandler: EventSinkHandler

    private val lifecycleCallbacks = object : Application.ActivityLifecycleCallbacks {
        override fun onActivityResumed(act: Activity) {
            if (act == activity) {
                _gameApp?.playMG()
            }
        }

        override fun onActivityPaused(act: Activity) {
            if (act == activity) {
                _gameApp?.pauseMG()
            }
        }

        // 可选实现其他方法
        override fun onActivityCreated(p0: Activity, p1: Bundle?) {}
        override fun onActivityStarted(p0: Activity) {}
        override fun onActivityStopped(p0: Activity) {}
        override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {}
        override fun onActivityDestroyed(p0: Activity) {}
    }

    constructor(
        activity: MainActivity,
        viewId: Int,
        creationParams: Map<String?, Any?>?,
        binding: FlutterPlugin.FlutterPluginBinding,
        eventSinkHandler: EventSinkHandler
    ) {
        this.context = activity
        this.activity = activity
        this.eventSinkHandler = eventSinkHandler
        this.methodChannel = MethodChannel(binding.binaryMessenger, "SudMGPPlugin")
        this.methodChannel.setMethodCallHandler(this)

        gameContainer = FrameLayout(activity)
        activity.application?.registerActivityLifecycleCallbacks(lifecycleCallbacks)
    }

    init {
        if (uiHandler == null) {
            uiHandler = Handler(Looper.getMainLooper())
        }
    }

    // method channel
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getVersion" -> {
                getVersion(call, result)
            }

            "initSDK" -> {
                initSDK(call, result)
            }

            "loadGame" -> {
                loadGame(call, result)
            }

            "pauseMG" -> {
                pauseMG(call, result)
            }

            "playMG" -> {
                playMG(call, result)
            }

            "destroyGame" -> {
                destroyGame(call, result)
            }

            "getGameList" -> {
                getGameList(call, result)
            }

            "updateCode" -> {
                updateCode(call, result)
            }

            "notifyStateChange" -> {
                notifyStateChange(call, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    fun getVersion(call: MethodCall, result: MethodChannel.Result) {
        var version = SudMGP.getVersion();
        result.success(mapOf("errorCode" to 0, "version" to version))
    }

    fun initSDK(call: MethodCall, result: MethodChannel.Result) {
        val appid: String? = call.argument<String>("appid")
        val appkey: String? = call.argument<String>("appkey")
        var isTestEnv: Boolean? = call.argument<Boolean>("isTestEnv")


        SudMGP.initSDK(context, appid, appkey, isTestEnv ?: false, object : ISudListenerInitSDK {
            override fun onSuccess() {
                result.success(mapOf("errorCode" to 0, "message" to "success"))
            }

            override fun onFailure(errorCode: Int, message: String) {
                result.success(mapOf("errorCode" to errorCode, "message" to message))
            }

        })
    }

    fun getGameList(call: MethodCall, result: MethodChannel.Result) {
        SudMGP.getMGList(object : ISudListenerGetMGList {
            override fun onSuccess(dataJson: String?) {
                result.success(mapOf("errorCode" to 0, "message" to "success", "dataJson" to dataJson))
            }

            override fun onFailure(errorCode: Int, message: String) {
                result.success(mapOf("errorCode" to errorCode, "message" to message))
            }
        })
    }

    fun destroyGame(call: MethodCall, result: MethodChannel.Result) {
        _gameApp?.destroyMG()
        _gameApp = null
        gameContainer.removeAllViews()
        result.success(mapOf("errorCode" to 0, "message" to "success"))
    }

    fun updateCode(call: MethodCall, result: MethodChannel.Result) {
        val code: String? = call.argument<String>("code")
        _gameApp?.updateCode(code ?: "", null)
        result.success(mapOf("errorCode" to 0, "message" to "success"))
    }

    fun notifyStateChange(call: MethodCall, result: MethodChannel.Result) {
        val state: String = call.argument<String>("state") ?: ""
        val dataJson: String = call.argument<String>("dataJson") ?: ""
        _gameApp?.notifyStateChange(state, dataJson, null)
        result.success(mapOf("errorCode" to 0, "message" to "success"))
    }

    fun loadGame(call: MethodCall, result: MethodChannel.Result) {
        val userid: String? = call.argument<String>("userid")
        val roomid: String? = call.argument<String>("roomid")
        val code: String? = call.argument<String>("code")
        var gameid: Long? = call.argument<Long>("gameid")
        val language: String? = call.argument<String>("language")
        _viewSize = call.argument<String>("viewSize")
        _gameConfig = call.argument<String>("gameConfig")

        _gameApp = SudMGP.loadMG(activity, userid, roomid, code, gameid ?: 0, language, object : ISudFSMMG {
            override fun onGameLog(dataJson: String?) {
                uiHandler?.post(Runnable { eventSinkHandler.eventSink?.success(mapOf("method" to "onGameLog", "dataJson" to dataJson)) })
            }

            override fun onGameLoadingProgress(p0: Int, p1: Int, p2: Int) {
            }

            override fun onGameStarted() {
                uiHandler?.post(Runnable { eventSinkHandler.eventSink?.success(mapOf("method" to "onGameStarted")) })
            }

            override fun onGameDestroyed() {
                uiHandler?.post(Runnable { eventSinkHandler.eventSink?.success(mapOf("method" to "onGameDestroyed")) })
            }

            override fun onExpireCode(handle: ISudFSMStateHandle?, dataJson: String?) {
                uiHandler?.post(Runnable { eventSinkHandler.eventSink?.success(mapOf("method" to "onExpireCode", "dataJson" to dataJson)) })
                handle?.success("{}")
            }

            override fun onGetGameViewInfo(handle: ISudFSMStateHandle?, dataJson: String?) {
                handle?.success(_viewSize)
            }

            override fun onGetGameCfg(handle: ISudFSMStateHandle?, dataJson: String?) {
                handle?.success(_gameConfig)
            }

            override fun onGameStateChange(handle: ISudFSMStateHandle?, state: String, dataJson: String) {
                uiHandler?.post(Runnable {
                    eventSinkHandler.eventSink?.success(
                        mapOf(
                            "method" to "onGameStateChange",
                            "dataJson" to dataJson,
                            "state" to state
                        )
                    )
                })
                handle?.success("{}")
            }

            override fun onPlayerStateChange(handle: ISudFSMStateHandle?, userId: String, state: String, dataJson: String) {
                uiHandler?.post(Runnable {
                    eventSinkHandler.eventSink?.success(
                        mapOf(
                            "method" to "onPlayerStateChange",
                            "dataJson" to dataJson,
                            "userId" to userId,
                            "state" to state
                        )
                    )
                })
                handle?.success("{}");
            }
        })

        _gameView = _gameApp?.gameView
        _gameView?.let {
            gameContainer.addView(it, FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT)
        }
        Log.d("sud", "kt sud gameView:$_gameView")
        result.success(mapOf("errorCode" to 0, "message" to "success"))
    }

    private fun pauseMG(call: MethodCall, result: MethodChannel.Result) {
        _gameApp?.pauseMG()
        result.success(mapOf("errorCode" to 0, "message" to "success"))
    }

    private fun playMG(call: MethodCall, result: MethodChannel.Result) {
        _gameApp?.playMG()
        result.success(mapOf("errorCode" to 0, "message" to "success"))
    }

    // PlatformView
    override fun getView(): View {
        Log.d("sud", "kt sud getView:$gameContainer")
        return gameContainer
    }

    override fun dispose() {
        activity?.application?.registerActivityLifecycleCallbacks(lifecycleCallbacks)
    }
}