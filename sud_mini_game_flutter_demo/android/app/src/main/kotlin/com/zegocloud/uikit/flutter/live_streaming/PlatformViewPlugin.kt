package com.zegocloud.uikit.flutter.live_streaming

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding

class PlatformViewPlugin(val activity: MainActivity) : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        binding.platformViewRegistry.registerViewFactory("SudMGPPluginView", NativeViewFactory(binding, activity))
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}
}