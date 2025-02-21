package com.correctsyntax.biblenotify;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Random;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class AlarmBroadcastReceiver extends BroadcastReceiver {
  // Set to the total number of verses in bible_verses.json (see info.txt)
  int NUM_OF_VERSES = 158;

  // Notification
  String CHANNEL_ID = "bibleNotify";
  NotificationChannel notificationChannel;
  CharSequence name = "Bible Notify";
  // make a random number
  Random rand = new Random();
  int randomNum = 0;

  String languagePath = "en";

  @Override
  public void onReceive(Context context, Intent intent) {
    // build and show notification
    //   Toast.makeText(context, " onReceive",Toast.LENGTH_SHORT).show();

    final SharedPreferences sharedPreferences = context.getSharedPreferences("bibleNotify", 0);

    // Random verse algorithm
    if (rand.nextInt(3) < 1) {

      SharedPreferences.Editor editor = sharedPreferences.edit();

      // lang
      languagePath = sharedPreferences.getString("languagePath", "en");

      int verseNumber = 0;
      if (sharedPreferences.contains("currentVerseNumber")) {
        verseNumber = sharedPreferences.getInt("currentVerseNumber", 0);
        editor.putInt("currentVerseNumber", verseNumber + 1);
      } else {
        editor.putInt("currentVerseNumber", verseNumber + 1);
      }
      editor.apply();

      randomNum = verseNumber;

    } else {
      randomNum = rand.nextInt(NUM_OF_VERSES - 1);
    }

    try {
      showNotification(
          context,
          pickBibleVerse(context, "verse"),
          pickBibleVerse(context, "place"),
          pickBibleVerse(context, "data"));

    } catch (Exception e) {
      Toast.makeText(context, e.toString(), Toast.LENGTH_SHORT).show();
    }

    // Start a new alarm
    SetAlarm.startAlarmBroadcastReceiver(context, sharedPreferences);
  }

  // build Notification
  public void showNotification(Context context, String bibleText, String bibleVerse, String data) {
    Intent notificationIntent = new Intent(context, BibleReader.class);
    Bundle bundle = new Bundle();
    notificationIntent.putExtras(bundle);
    notificationIntent.setFlags(
        Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_MULTIPLE_TASK);

    PendingIntent contentIntent;
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      contentIntent =
          PendingIntent.getActivity(
              context,
              0,
              notificationIntent,
              PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

    } else {
      contentIntent =
          PendingIntent.getActivity(
              context, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      notificationChannel =
          new NotificationChannel(CHANNEL_ID, name, NotificationManager.IMPORTANCE_HIGH);
    }

    NotificationManager mNotificationManager =
        (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      mNotificationManager.createNotificationChannel(notificationChannel);
    }

    /* save verse data(date) so we know what
    to show when user opens reader  */
    final SharedPreferences sharedPreferences = context.getSharedPreferences("bibleNotify", 0);

    SharedPreferences.Editor editor = sharedPreferences.edit();
    editor.putString("readerData", data);
    editor.putString("readerDataVerseNumber", bibleVerse.split(":")[1].replace(" (story)", ""));
    editor.apply();

    // More for Notification
    Notification.BigTextStyle bigText = new Notification.BigTextStyle();
    bigText.bigText(bibleText);
    bigText.setSummaryText(bibleVerse);

    Notification.Builder NotificationBuilder;

    // check Android API and do as needed

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      NotificationBuilder = new Notification.Builder(context, CHANNEL_ID);
    } else {
      NotificationBuilder = new Notification.Builder(context);
    }
    Notification.Builder mBuilder = NotificationBuilder;

    mBuilder.setSmallIcon(R.drawable.nicon);
    mBuilder.setContentTitle(context.getString(R.string.notification_title));
    mBuilder.setContentText(bibleVerse);
    mBuilder.setStyle(bigText);
    mBuilder.setAutoCancel(true);
    mBuilder.setContentIntent(contentIntent);

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      mBuilder.setChannelId(CHANNEL_ID);
    }

    mNotificationManager.notify(1, mBuilder.build());
  }

  //  Parse Json file to get verse data
  public String pickBibleVerse(Context context, String whichPart) {
    String name;

    try {
      // get JSONObject from JSON file
      JSONObject obj = new JSONObject(loadJSONFromAsset(context));

      // fetch JSONArray named users
      JSONArray userArray = obj.getJSONArray("all");

      try {
        JSONObject userDetail = userArray.getJSONObject(randomNum);
        name = userDetail.getString(whichPart);

      } catch (JSONException e) {
        Log.d("ERROR", String.valueOf(e));
        return "ERROR: " + e;
      }

    } catch (JSONException e) {
      Log.d("ERROR", String.valueOf(e));
      return "ERROR: " + e;
    }

    return name;
  }

  // load json file from App Asset
  public String loadJSONFromAsset(Context context) {
    String json;
    try {
      InputStream is =
          context.getAssets().open("bible/" + languagePath + "/Verses/bible_verses.json");
      int size = is.available();
      byte[] buffer = new byte[size];
      is.read(buffer);
      is.close();
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
        json = new String(buffer, StandardCharsets.UTF_8);
      } else {
        json = new String(buffer, StandardCharsets.UTF_8);
      }
    } catch (IOException ex) {
      Log.d("ERROR", String.valueOf(ex));
      Toast.makeText(context, "Bible Verse Text Files Not Found: " + ex, Toast.LENGTH_SHORT).show();
      return null;
    }
    return json;
  }
}
