package com.example.vpn_services

import android.net.VpnService
import android.content.Intent
import android.os.ParcelFileDescriptor
import android.util.Log
import android.widget.Toast

class MyVpnService : VpnService() {
    private var vpnInterface: ParcelFileDescriptor? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("MyVpnService", "VPN Service started")
        Toast.makeText(this, "VPN Service started", Toast.LENGTH_SHORT).show()

        // Build a minimal VPN interface
        val builder = Builder()
        builder.setSession("MyVPN")
            .addAddress("10.0.0.2", 24) // Fake local VPN IP
            .addDnsServer("8.8.8.8")    // Google DNS
            .addRoute("0.0.0.0", 0)     // Route all traffic

        vpnInterface?.close()
        vpnInterface = builder.establish()

        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        vpnInterface?.close()
        vpnInterface = null
    }
}