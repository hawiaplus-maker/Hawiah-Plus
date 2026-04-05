package com.hawiah.plus

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.snapchat.kit.sdk.advertising.SCSDKAdvertising

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.hawiah.plus/snapchat_ads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "trackEvent") {
                val eventName = call.argument<String>("eventName")
                if (eventName != null) {
                    SCSDKAdvertising.track(this, eventName)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "Event name is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
