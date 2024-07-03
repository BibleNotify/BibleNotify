package com.correctsyntax.biblenotify;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

import java.util.Objects;

public class RebootReceiver extends BroadcastReceiver {

  @Override
  public void onReceive(Context context, Intent intent) {

    if (Objects.equals(intent.getAction(), "android.intent.action.BOOT_COMPLETED")) {
      final SharedPreferences sharedPreferences = context.getSharedPreferences("bibleNotify", 0);
      SetAlarm.startAlarmBroadcastReceiver(context, sharedPreferences);
    }
  }
}
