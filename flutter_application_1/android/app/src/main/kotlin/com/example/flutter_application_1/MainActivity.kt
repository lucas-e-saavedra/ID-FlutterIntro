package com.example.flutter_application_1

import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/tokbox";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "beginVideoCall"){
                val apiKey = call.argument<String>("apiKey") ?:""
                val sessionId = call.argument<String>("sessionId") ?:""
                val sessionToken = call.argument<String>("sessionToken") ?:""

                Log.i("flutternative",apiKey)
                Log.i("flutternative",sessionId)
                Log.i("flutternative",sessionToken)

                Toast.makeText(this, "apiKey: "+apiKey, Toast.LENGTH_SHORT).show()
                Toast.makeText(this, "sessionId: "+sessionId, Toast.LENGTH_SHORT).show()
                Toast.makeText(this, "sessionToken: "+sessionToken, Toast.LENGTH_SHORT).show()

                startActivity(VideoCallActivity.newIntent(this@MainActivity, apiKey, sessionId, sessionToken))
                result.success("OK")
            }else{
                result.notImplemented()
            }
        }
    }
}
