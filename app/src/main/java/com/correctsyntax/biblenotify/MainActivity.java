package com.correctsyntax.biblenotify;

import android.app.AlarmManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageButton;
import android.widget.TimePicker;
import android.widget.Toast;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {

  ImageButton startBtn, changeBtn, helpBtn, languagesBtn;
  Animation animFadeOut;

  public static int hourToSet = 12;
  public static int minToSet = 0;

  public static int hourToBeSaved = 12;
  public static int minToBeSaved = 0;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    startBtn = findViewById(R.id.start_button);
    changeBtn = findViewById(R.id.change_button);
    helpBtn = findViewById(R.id.help_button);
    languagesBtn = findViewById(R.id.languages_button);

    final SharedPreferences sharedPreferences =
        getApplicationContext().getSharedPreferences("bibleNotify", MODE_PRIVATE);

    // If enabled set image to done
    if (sharedPreferences.contains("Started")) {
      startBtn.setImageResource(R.drawable.ic_pause_sending_button);
    }

    // Auto set the language
    SharedPreferences.Editor editor = sharedPreferences.edit();
    editor.putString("language", Locale.getDefault().getDisplayLanguage());
    editor.putString("languagePath", Locale.getDefault().getLanguage());
    editor.apply();

    // Start Button
    startBtn.setOnClickListener(
        v -> {
          if (sharedPreferences.contains("Started")
              && sharedPreferences.getString("Started", "no").equals("yes")) {
            Toast.makeText(getApplicationContext(), "Bible Notify is running", Toast.LENGTH_SHORT)
                .show();
          } else {
            // tell that it has been enabled
            editor.putString("Started", "yes");
            editor.commit();

            /* Make Alert dialog */
            AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
            LayoutInflater inflater = MainActivity.this.getLayoutInflater();
            builder.setCancelable(false);
            View v_ = inflater.inflate(R.layout.start_dialog, null);
            builder.setView(v_);
            builder.setTitle("Set Time");
            builder
                .setMessage("Send notification at:")
                .setPositiveButton(
                    "ok",
                    (dialog, id) -> {
                      // save time
                      SharedPreferences.Editor editor1 = sharedPreferences.edit();
                      editor1.putInt("SetTimeH", hourToBeSaved);
                      editor1.putInt("SetTimeM", minToBeSaved);
                      editor1.commit();

                      SetAlarm.startAlarmBroadcastReceiver(MainActivity.this, sharedPreferences);
                      Toast.makeText(getApplicationContext(), "Saved", Toast.LENGTH_SHORT).show();

                      // Animation
                      animFadeOut =
                          AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fade_out);
                      startBtn.setVisibility(View.VISIBLE);
                      startBtn.startAnimation(animFadeOut);
                      startBtn.setImageResource(R.drawable.ic_pause_sending_button);
                    })
                .setNeutralButton(
                    "Cancel",
                    (dialog, id) -> {
                      SharedPreferences.Editor editor12 = sharedPreferences.edit();
                      editor12.putString("Started", "No");
                      editor12.commit();
                    })
                .create()
                .show();
            // get time picker object
            TimePicker input = v_.findViewById(R.id.start_time_picker);

            // set event Listener on Time picker
            input.setOnTimeChangedListener(
                (timePicker, H, M) -> {
                  hourToBeSaved = H;
                  minToBeSaved = M;
                });

            // set time

            // get currently set time from sharedPreferences
            if (sharedPreferences.getString("Started", "no").equals("yes")) {
              hourToSet = sharedPreferences.getInt("SetTimeH", 0);
              minToSet = sharedPreferences.getInt("SetTimeM", 0);
            }

            if (android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.LOLLIPOP_MR1) {
              input.setCurrentHour(hourToSet);
              input.setCurrentMinute(minToSet);
            } else {
              input.setHour(hourToSet);
              input.setMinute(minToSet);
            }
          }
        });

    // Settings (Change time)
    changeBtn.setOnClickListener(
        v -> {
          if (sharedPreferences.contains("Started")
              && sharedPreferences.getString("Started", "no").equals("yes")) {
            Intent settingsIntent = new Intent(MainActivity.this, SettingsActivity.class);
            startActivity(settingsIntent);
          } else {
            Toast.makeText(
                    getApplicationContext(),
                    "You must start sending notifications first",
                    Toast.LENGTH_LONG)
                .show();
          }
        });

    // Help
    helpBtn.setOnClickListener(
        v -> {
          Intent helpIntent = new Intent(MainActivity.this, HelpActivity.class);
          startActivity(helpIntent);
        });

    // Languages
    languagesBtn.setOnClickListener(
        v -> {
          Intent languagesIntent = new Intent(MainActivity.this, LanguageSettings.class);
          startActivity(languagesIntent);
        });
  }

  @Override
  protected void onResume() {
    super.onResume();
    // Check if the app can schedule exact alarms
    AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !alarmManager.canScheduleExactAlarms()) {
      // If not, request the SCHEDULE_EXACT_ALARM permission
      Toast.makeText(
              getApplicationContext(),
              "Permission for notifications needed on Android 14+",
              Toast.LENGTH_LONG)
          .show();
      Intent intent = new Intent(android.provider.Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM);
      intent.setData(Uri.fromParts("package", getPackageName(), null));
      startActivity(intent);
    }
  }
}
