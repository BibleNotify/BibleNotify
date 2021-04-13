package com.correctsyntax.biblenotify;


import android.content.Intent;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.SharedPreferences;
import java.util.Calendar;
import android.content.Context;


public class setAlarm {
    public static int hour = 12;
    public static int min = 0;
    /* for sec */
    public static int sec = 0;


    public static void startAlarmBroadcastReceiver(Context context, SharedPreferences sharedPreferences) {

        // get time
        if (sharedPreferences.contains("SetTimeH")) {
            min = sharedPreferences.getInt("SetTimeM", 0);
            hour = sharedPreferences.getInt("SetTimeH", 0);
        }


        // Start Alarm
            Intent _intent = new Intent(context, AlarmBroadcastReceiver.class);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, _intent, PendingIntent.FLAG_UPDATE_CURRENT);
            AlarmManager alarmManager = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);


            alarmManager.cancel(pendingIntent);
            Calendar calendar = Calendar.getInstance();
            calendar.setTimeInMillis(System.currentTimeMillis());
            calendar.set(Calendar.HOUR_OF_DAY, hour);
            calendar.set(Calendar.MINUTE, min);
            calendar.set(Calendar.SECOND, sec);
            alarmManager.set(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);

    }


}


