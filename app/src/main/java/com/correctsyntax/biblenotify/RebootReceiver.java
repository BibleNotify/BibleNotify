package com.correctsyntax.biblenotify;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

public class RebootReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {

        if (intent.getAction().equals("android.intent.action.BOOT_COMPLETED")) {
            final SharedPreferences sharedPreferences = context.getSharedPreferences("bibleNotify", 0);
            SetAlarm.startAlarmBroadcastReceiver(context, sharedPreferences);
        }
    }
}
