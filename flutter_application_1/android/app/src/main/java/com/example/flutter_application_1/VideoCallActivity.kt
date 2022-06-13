package com.example.flutter_application_1

import android.Manifest
import android.content.Context
import android.content.Intent
import android.opengl.GLSurfaceView
import android.os.Bundle
import android.util.Log
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import com.opentok.android.*
import com.opentok.android.PublisherKit.PublisherListener
import com.opentok.android.Session.SessionListener
import com.opentok.android.SubscriberKit.SubscriberListener
import pub.devrel.easypermissions.AfterPermissionGranted
import pub.devrel.easypermissions.EasyPermissions


class VideoCallActivity : AppCompatActivity() {
    companion object{
        const val PERMISSIONS_REQUEST_CODE = 530
        @JvmStatic
        fun newIntent(ctx: Context, apiKey: String, sessionId: String, sessionToken: String): Intent {
            val intent = Intent(ctx, VideoCallActivity::class.java)
            intent.putExtra("API_KEY", apiKey)
            intent.putExtra("SESSION_ID", sessionId)
            intent.putExtra("TOKEN", sessionToken)
            return intent
        }
    }

    private var session: Session? = null
    private var publisher: Publisher? = null
    private var subscriber: Subscriber? = null

    private val publisherViewContainer: FrameLayout? by lazy { findViewById(R.id.publisher_container) }
    private val subscriberViewContainer: FrameLayout? by lazy { findViewById(R.id.subscriber_container) }
    private val TAG = VideoCallActivity::class.java.simpleName

    private fun getApiKey():String = intent.getStringExtra("API_KEY") ?:""
    private fun getSessionId():String = intent.getStringExtra("SESSION_ID") ?:""
    private fun getSessionToken():String = intent.getStringExtra("TOKEN") ?:""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_video_call)
        Log.i("flutternative:"+TAG, "onCreate()")
        requestPermissions()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        val stringPermissions : String = permissions.joinToString()
        val stringGrant : String = grantResults.joinToString()
        Log.i("flutternative:"+TAG, "onRequestPermissionsResult requestcode: $requestCode stringPermissions: $stringPermissions stringGrant: $stringGrant")
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        EasyPermissions.onRequestPermissionsResult(requestCode, permissions, grantResults, this)
    }

    @AfterPermissionGranted(PERMISSIONS_REQUEST_CODE)
    fun requestPermissions() {
        Log.i("flutternative:"+TAG, "requestPermissions()")
        val perms = arrayOf(Manifest.permission.INTERNET, Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO)
        if (EasyPermissions.hasPermissions(this, *perms)) {
            initializeSession(getApiKey(), getSessionId(), getSessionToken());
        } else {
            Log.i("flutternative:"+TAG, "EasyPermissions.requestPermissions")
            EasyPermissions.requestPermissions(
                this@VideoCallActivity,
                "This app needs access to your camera and mic to make video calls",
                PERMISSIONS_REQUEST_CODE,
                *perms
            )
        }
    }

    private fun initializeSession(apiKey: String, sessionId: String, token: String) {
        Log.i("flutternative:"+TAG, "initializeSession \napiKey: $apiKey \nsessionId: $sessionId \ntoken: $token")
        session = Session.Builder(this, apiKey, sessionId).build()
        session?.setSessionListener(sessionListener)
        session?.connect(token)
    }


    private val sessionListener: SessionListener = object : SessionListener {
        override fun onConnected(session: Session) {
            Log.i("flutternative:"+TAG, "onConnected: Connected to session: " + session.sessionId)
            publisher = Publisher.Builder(this@VideoCallActivity).build()
            publisher?.setPublisherListener(publisherListener)
            publisher?.getRenderer()?.setStyle(BaseVideoRenderer.STYLE_VIDEO_SCALE, BaseVideoRenderer.STYLE_VIDEO_FILL)
            publisherViewContainer!!.addView(publisher?.getView())
            if (publisher?.getView() is GLSurfaceView) {
                (publisher?.getView() as GLSurfaceView).setZOrderOnTop(true)
            }
            session.publish(publisher)
        }

        override fun onDisconnected(session: Session) {
            Log.i("flutternative:"+TAG, "onDisconnected: Disconnected from session: " + session.sessionId)
        }

        override fun onStreamReceived(session: Session, stream: Stream) {
            Log.i("flutternative:"+TAG,
                "onStreamReceived: New Stream Received " + stream.streamId.toString() + " in session: " + session.sessionId
            )
            if (subscriber == null) {
                subscriber = Subscriber.Builder(this@VideoCallActivity, stream).build()
                subscriber?.getRenderer()?.setStyle(
                    BaseVideoRenderer.STYLE_VIDEO_SCALE,
                    BaseVideoRenderer.STYLE_VIDEO_FILL
                )
                subscriber?.setSubscriberListener(subscriberListener)
                session.subscribe(subscriber)
                subscriberViewContainer!!.addView(subscriber?.getView())
            }
        }

        override fun onStreamDropped(session: Session?, stream: Stream?) {
            Log.i("flutternative:"+TAG,"onStreamDropped: Stream Dropped: " + stream?.getStreamId()?.toString() + " in session: " + session?.sessionId)
            if (subscriber != null) {
                subscriber = null
                subscriberViewContainer!!.removeAllViews()
            }
        }

        override fun onError(session: Session, opentokError: OpentokError) {
            Log.i("flutternative:"+TAG, "Session error: " + opentokError.message)
        }
    }

    private val publisherListener: PublisherListener = object : PublisherListener {
        override fun onStreamCreated(publisherKit: PublisherKit?, stream: Stream) {
            Log.i("flutternative:"+TAG, "onStreamCreated: Publisher Stream Created. Own stream " + stream.streamId)
        }

        override fun onStreamDestroyed(publisherKit: PublisherKit?, stream: Stream) {
            Log.i("flutternative:"+TAG,
                "onStreamDestroyed: Publisher Stream Destroyed. Own stream " + stream.streamId
            )
        }

        override fun onError(publisherKit: PublisherKit, opentokError: OpentokError) {
            Log.i("flutternative:"+TAG, "PublisherKit onError: " + opentokError.message)
        }
    }

    var subscriberListener: SubscriberListener = object : SubscriberListener {
        override fun onConnected(subscriberKit: SubscriberKit) {
            Log.i("flutternative:"+TAG,
                "onConnected: Subscriber connected. Stream: " + subscriberKit.stream.streamId
            )
        }

        override fun onDisconnected(subscriberKit: SubscriberKit) {
            Log.i("flutternative:"+TAG,
                "onDisconnected: Subscriber disconnected. Stream: " + subscriberKit.stream.streamId
            )
        }

        override fun onError(subscriberKit: SubscriberKit, opentokError: OpentokError) {
            Log.i("flutternative:"+TAG, "SubscriberKit onError: " + opentokError.message)
        }
    }


    override fun onPause() {
        super.onPause()
        if (session != null) {
            session!!.onPause()
        }
    }

    override fun onResume() {
        super.onResume()
        if (session != null) {
            session!!.onResume()
        }
    }
}