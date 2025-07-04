package com.example.addict_blocker2

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Intent
import android.os.Bundle
import android.preference.PreferenceManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.addict_blocker2/admin"

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
                intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "Admin access is needed to block apps.")
                startActivity(intent)
                result.success(null)
            } else if (call.method == "updateBlockedApps") {
                val blockedApps = call.argument<List<String>>("blockedApps") ?: emptyList()
                val prefs = PreferenceManager.getDefaultSharedPreferences(this)
                prefs.edit().putStringSet("blocked_apps", blockedApps.toSet()).apply()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Handle intent from AccessibilityService
        val blockedApp = intent.getStringExtra("blocked_app")
        if (blockedApp != null) {
            // Send message to Flutter via MethodChannel or EventChannel if needed
        }
    }
}
