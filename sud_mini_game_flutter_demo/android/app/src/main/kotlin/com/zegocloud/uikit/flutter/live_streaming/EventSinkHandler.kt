package com.zegocloud.uikit.flutter.live_streaming

import io.flutter.plugin.common.EventChannel


class EventSinkHandler : EventChannel.StreamHandler {

    var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

}