package com.example.addict_blocker2

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.content.SharedPreferences
import android.preference.PreferenceManager
import android.view.accessibility.AccessibilityEvent

class MyAccessibilityService : AccessibilityService() {
    private lateinit var prefs: SharedPreferences

    override fun onServiceConnected() {
        super.onServiceConnected()
        prefs = PreferenceManager.getDefaultSharedPreferences(this)
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        // Block YouTube app (example)
        if (event.packageName == "com.google.android.youtube") {
            performGlobalAction(GLOBAL_ACTION_BACK)
            return
        }

        // Block YouTube website in Chrome (example)
        if (event.packageName == "com.android.chrome") {
            event.text?.forEach { text ->
                val url = text.toString()
                if (url.contains("youtube.com", ignoreCase = true)) {
                    performGlobalAction(GLOBAL_ACTION_BACK)
                    return
                }
            }
        }

        // Block any app in the blocked list
        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString() ?: return
            val blockedApps = prefs.getStringSet("blocked_apps", emptySet()) ?: emptySet()
            if (blockedApps.contains(packageName)) {
                // Kick user out and launch Flutter app with a message
                performGlobalAction(GLOBAL_ACTION_HOME)
                val intent = Intent(this, MainActivity::class.java)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                intent.putExtra("blocked_app", packageName)
                startActivity(intent)
            }
        }
    }

    override fun onInterrupt() {}
}