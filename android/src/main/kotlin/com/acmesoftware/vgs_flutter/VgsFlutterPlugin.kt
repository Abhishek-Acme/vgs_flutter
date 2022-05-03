package com.acmesoftware.vgs_flutter

import android.app.Activity
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.verygoodsecurity.vgscollect.core.Environment
import com.verygoodsecurity.vgscollect.core.HTTPMethod
import com.verygoodsecurity.vgscollect.core.VGSCollect
import com.verygoodsecurity.vgscollect.core.VgsCollectResponseListener
import com.verygoodsecurity.vgscollect.core.model.network.VGSResponse
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** VgsFlutterPlugin */
class VgsFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var result: Result? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vgs_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        this.result = result

        when (call.method) {
            "sendData" -> {
                val headers = call.argument<Map<String, String>>("headers") ?: mapOf()
                val vaultId = call.argument<String>("vaultId") ?: ""
                val sandbox = call.argument<Boolean>("sandbox") ?: true
                val path = call.argument<Boolean>("path") ?: true
                val data = call.argument<Map<String, Any>>("data")

                sendData(vaultId, sandbox, headers, data,path)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        result = null
    }

    private fun sendData(id: String, sandbox: Boolean, headers: Map<String, String>, data: Map<String, Any>?,path:String) {
        if (activity == null) {
            result?.error("NO_CONTEXT", "", "")
            return
        }

        val collect = VGSCollect(activity!!, id, if (sandbox) Environment.SANDBOX else Environment.LIVE)

        collect.setCustomHeaders(headers)
        collect.setCustomData(data)

        collect.clearResponseListeners()

        collect.asyncSubmit(path, HTTPMethod.POST)

        collect.addOnResponseListeners(
                object : VgsCollectResponseListener {
                    override fun onResponse(response: VGSResponse?) {
                        when (response) {
                            is VGSResponse.SuccessResponse -> result?.success(response.body)
                            is VGSResponse.ErrorResponse -> {
                                result?.error(response.errorCode.toString(), response.localizeMessage, response.body)
                            }
                            else -> result?.error("NO_RESPONSE", null, null)
                        }
                    }
                }
        )
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() { }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) { }

    override fun onDetachedFromActivity() {
        activity = null
    }


}
