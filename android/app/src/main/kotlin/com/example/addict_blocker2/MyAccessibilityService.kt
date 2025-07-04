package com.example.vpn_services

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.util.Log

class MyAccessibilityService : AccessibilityService() {
    // Hardcoded blocklist for demonstration. You can make this dynamic later.
    private val blockedDomains = setOf("youtube.com")
    private val blockedPackages = setOf("com.google.android.youtube")

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        // Block YouTube app
        if (blockedPackages.contains(event.packageName)) {
            performGlobalAction(GLOBAL_ACTION_BACK)
            return
        }

        // Block YouTube website in Chrome
        if (event.packageName == "com.android.chrome") {
            event.text?.forEach { text ->
                val url = text.toString()
                blockedDomains.forEach { domain ->
                    if (url.contains(domain, ignoreCase = true)) {
                        performGlobalAction(GLOBAL_ACTION_BACK)
                        return
                    }
                }
            }
        }
    }

    override fun onInterrupt() {}
}