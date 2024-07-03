package com.correctsyntax.biblenotify;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import java.util.Calendar;
import java.util.Date;

public class SetAlarm {

  public static int hour = 12;
  public static int min = 0;

  public static void startAlarmBroadcastReceiver(
      Context context, SharedPreferences sharedPreferences) {

    // get time
    if (sharedPreferences.contains("SetTimeH")) {
      min = sharedPreferences.getInt("SetTimeM", 0);
      hour = sharedPreferences.getInt("SetTimeH", 0);
    }

    // Start Alarm
    Intent _intent = new Intent(context, AlarmBroadcastReceiver.class);
    PendingIntent pendingIntent;
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      pendingIntent =
          PendingIntent.getBroadcast(
              context,
              0,
              _intent,
              PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT);
    } else {
      pendingIntent =
          PendingIntent.getBroadcast(context, 0, _intent, PendingIntent.FLAG_UPDATE_CURRENT);
    }
    AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);

    alarmManager.cancel(pendingIntent);
    Calendar calendar = Calendar.getInstance();
    calendar.set(Calendar.HOUR_OF_DAY, hour);
    calendar.set(Calendar.MINUTE, min);
    calendar.set(Calendar.SECOND, 0);
    calendar.set(Calendar.MILLISECOND, 0);

    if (calendar.getTime().compareTo(new Date()) < 0) {
      calendar.add(Calendar.DAY_OF_MONTH, 1);
    }

    boolean canScheduleExactAlarms;
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
      canScheduleExactAlarms = alarmManager.canScheduleExactAlarms();
    } else {
      canScheduleExactAlarms = true;
    }

    // SDK 18 and below
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
      alarmManager.set(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
    }
    // SDK 19 to 22
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT
        && Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
      alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
    }
    // SDK 23 +
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      if (!canScheduleExactAlarms) return;
      alarmManager.setExactAndAllowWhileIdle(
          AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
    }
  }
}
