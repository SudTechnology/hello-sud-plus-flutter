package com.zegocloud.uikit.flutter.live_streaming

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory(val binding: FlutterPlugin.FlutterPluginBinding, val activity: MainActivity, val eventSinkHandler: EventSinkHandler) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return SudMGPPlugin(activity, viewId, creationParams, binding, eventSinkHandler)
    }

}