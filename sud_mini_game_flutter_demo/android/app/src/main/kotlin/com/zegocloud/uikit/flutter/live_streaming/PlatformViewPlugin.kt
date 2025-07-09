package com.zegocloud.uikit.flutter.live_streaming

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.EventChannel

class PlatformViewPlugin(val activity: MainActivity) : FlutterPlugin {

    private var eventChannel: EventChannel? = null
    private var eventSinkHandler: EventSinkHandler? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        eventChannel = EventChannel(binding.binaryMessenger, "SudMGPPluginEvent")
        val eventSinkHandler = EventSinkHandler()
        this.eventSinkHandler = eventSinkHandler
        eventChannel?.setStreamHandler(eventSinkHandler)
        binding.platformViewRegistry.registerViewFactory("SudMGPPluginView", NativeViewFactory(binding, activity, eventSinkHandler))
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        eventSinkHandler = null
        eventChannel?.setStreamHandler(null)
        eventChannel = null
    }
}