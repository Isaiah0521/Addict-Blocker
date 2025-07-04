package com.example.addict_blocker2

import android.accessibilityservice.AccessibilityService
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.view.accessibility.AccessibilityEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.yourapp/admin"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.addict_blocker2/accessibility")
            .setMethodCallHandler { call, result ->
                if (call.method == "openAccessibilitySettings") {
                    val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                    startActivity(intent)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "requestAdmin") {
                val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN)
                val componentName = ComponentName(this, MyDeviceAdminReceiver::class.java)
                intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, componentName)
                intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "Needed to block websites.")
                startActivity(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}

class MyAccessibilityService : AccessibilityService() {
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // TODO: Add logic to monitor/block apps or websites here
    }

    override fun onInterrupt() {}
}
