package id.co.superindo.superninja;

import android.content.Context;
import android.text.TextUtils;

import com.google.firebase.messaging.FirebaseMessaging;
import com.netcore.android.Smartech;
import com.netcore.android.logger.SMTDebugLevel;
import com.smartech.flutter.smartech_plugin.SmartechPlugin;

import java.lang.ref.WeakReference;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;

public class Application extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
        SmartechPlugin.Companion.initializePlugin(this);
        Smartech smartech = Smartech.getInstance(new WeakReference<>(this.getApplicationContext()));
        smartech.trackAppInstallUpdateBySmartech();
        smartech.setDebugLevel(SMTDebugLevel.Level.VERBOSE);
        fetchFCMToken(this);
        smartech.fetchAlreadyGeneratedTokenFromFCM();
    }

    private static void fetchFCMToken(Context context) {
        try {
            FirebaseMessaging.getInstance().getToken()
                    .addOnCompleteListener(task -> {
                        if (task.isSuccessful() && !TextUtils.isEmpty(task.getResult())) {
                            Smartech smartech = Smartech.getInstance(new WeakReference<>(context));
                            String fcmToken = task.getResult();
                            String currentToken = smartech.getDevicePushToken();

                            if (TextUtils.isEmpty(currentToken)) {
                                smartech.setDevicePushToken(fcmToken);
                            } else if (!currentToken.equals(fcmToken)) {
                                smartech.setDevicePushToken(fcmToken);
                            }
                        }
                    });
        } catch (Exception ignored) {
        }
    }

    @Override
    public void registerWith(PluginRegistry registry) {
//        FirebaseCloudMessagingPluginRegistrant.registerWith(registry);
    }
}
