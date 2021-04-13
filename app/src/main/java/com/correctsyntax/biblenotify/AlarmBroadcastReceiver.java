package com.correctsyntax.biblenotify;

import android.content.Intent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.os.Bundle;
import android.app.NotificationManager;
import android.app.Notification;
import android.app.PendingIntent;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Random;
import android.content.SharedPreferences;
import android.app.AlarmManager;
import android.widget.Toast;
import android.app.NotificationChannel;

public class AlarmBroadcastReceiver extends BroadcastReceiver {



    // Notification
    String CHANNEL_ID = "biblenotify";
    NotificationChannel notificationChannel;
    CharSequence name = "Bible Notify";




    // make a random number
    Random rand = new Random();
    int rand_num = rand.nextInt(146);

    @Override
    public void onReceive(Context context, Intent intent) {
        // build and show notification

        try{

            showNotification(context, pickBibleVerse(context, "verse"), pickBibleVerse(context, "place"), pickBibleVerse(context, "data"));

        }catch (Exception e){
            Toast.makeText(context,e.toString(),Toast.LENGTH_SHORT).show();
        }


            // Start a new alarm
        Intent intent1 = new Intent(context, AlarmBroadcastReceiver.class);
        final PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 100, intent1, 0);
        final AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        alarmManager.set(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + (1000 * 60 * 60 * 24), pendingIntent);


    }

        // build Notification
    public void showNotification(Context context, String bibleText, String bibleVerse, String data) {

            Intent notificationIntent = new Intent(context, bibleReader.class);
            Bundle bundle = new Bundle();
            notificationIntent.putExtras(bundle);
            notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_MULTIPLE_TASK);
            PendingIntent contentIntent = PendingIntent.getActivity(context, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

            if(android.os.Build.VERSION.SDK_INT  >= android.os.Build.VERSION_CODES.O) {
                notificationChannel = new NotificationChannel(CHANNEL_ID, name, NotificationManager.IMPORTANCE_HIGH);
            }

            NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

            if (android.os.Build.VERSION.SDK_INT  >= android.os.Build.VERSION_CODES.O) {
                mNotificationManager.createNotificationChannel(notificationChannel);
            }



            /** save verse data so we know what
             to show when user opens reader  **/
            final SharedPreferences sharedPreferences = context.getSharedPreferences("bibleNotify", 0);

            SharedPreferences.Editor editor = sharedPreferences.edit();
            editor.putString("readerData", data);
            editor.commit();

            // More for Notification
            Notification.BigTextStyle bigText = new Notification.BigTextStyle();
            bigText.bigText(bibleText);
            bigText.setSummaryText(bibleVerse);

            Notification.Builder NotificationBuilder;

            // check Android API and do as needed

            if (android.os.Build.VERSION.SDK_INT  >= android.os.Build.VERSION_CODES.O) {
                NotificationBuilder = new Notification.Builder(context, CHANNEL_ID);
            } else {
                NotificationBuilder = new Notification.Builder(context);
            }
            Notification.Builder mBuilder = NotificationBuilder;

            mBuilder.setSmallIcon(R.drawable.nicon);
            mBuilder.setContentTitle("A Word From The Scriptures");
            mBuilder.setContentText(bibleVerse);
            mBuilder.setStyle(bigText);
            mBuilder.setAutoCancel(true);
            mBuilder.setContentIntent(contentIntent);

            if (android.os.Build.VERSION.SDK_INT  >= android.os.Build.VERSION_CODES.O) {
                mBuilder.setChannelId(CHANNEL_ID);
            }

            mNotificationManager.notify(1, mBuilder.build());

    }

    //  Parse Json file to get verse data
    public String pickBibleVerse(Context context, String whichpart) {
        String name = null;

        try {
            // get JSONObject from JSON file
            JSONObject obj = new JSONObject(loadJSONFromAsset(context));

            // fetch JSONArray named users
            JSONArray userArray = obj.getJSONArray("all");

            try {
                JSONObject userDetail = userArray.getJSONObject(rand_num);
                name = userDetail.getString(whichpart);

            }catch (JSONException e){

                String s= "ERROR: " + e.toString();
                return s;
            }

        }
        catch (JSONException e) {

            String k= "ERROR: " + e.toString();
            return k;
        }

        return name;

    }
    // load json file from App Asset
    public String loadJSONFromAsset(Context context) {
        String json = null;
        try {

            InputStream is = context.getAssets().open("bible/Verses/bible_verse.json");
            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            json = new String(buffer, StandardCharsets.UTF_8);
        } catch (IOException ex) {

            return null;
        }
        return json;
    }
}
