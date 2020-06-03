package io.dhruvam.project_runway

import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.lang.Exception


class MainActivity: FlutterActivity() {
    private var sharedText: String = ""
    private var oldText: String = ""

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        // handle incoming text
        catchIncomingText()
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app.channel.shared.data").setMethodCallHandler { call, result ->
            if (call.method == "getSharedText") {
                // intent always has the text stored
                // so check if the text is same as
                // the previous text
                if (oldText == sharedText) {
                    result.success("empty_8ebddc3a-a5d8-11ea-bb37-0242ac130002")
                } else {
                    result.success(sharedText)
                }
                oldText = sharedText
                sharedText = ""
            }
        }
    }

    private fun handleSendText(intent: Intent) {
        sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)!!
    }

    private fun catchIncomingText() {
        try {
            val intent = intent
            val action = intent.action
            val type = intent.type
            if (Intent.ACTION_SEND == action && type != null) {
                if ("text/plain" == type) {
                    handleSendText(intent); // Handle text being sent
                }
            }
        } catch (ex: Exception) {
            sharedText = ""
        }
    }
}
