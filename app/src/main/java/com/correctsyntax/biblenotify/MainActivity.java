package com.correctsyntax.biblenotify;

import android.app.AlarmManager;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TimePicker;
import android.widget.Toast;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import com.google.android.material.button.MaterialButton;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {
  ImageButton helpBtn, languagesBtn;
  Button startBtn, changeBtn;

  public static int hourToSet = 12;
  public static int minToSet = 0;

  public static int hourToBeSaved = 12;
  public static int minToBeSaved = 0;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    ConstraintLayout topbar = findViewById(R.id.top_bar);

    ViewCompat.setOnApplyWindowInsetsListener(
        topbar,
        (v, windowInsets) -> {
          Insets insets = windowInsets.getInsets(WindowInsetsCompat.Type.systemBars());
          // Apply the insets as a margin to the view. This solution sets only the
          // bottom, left, and right dimensions, but you can apply whichever insets are
          // appropriate to your layout. You can also update the view padding if that's
          // more appropriate.
          ViewGroup.MarginLayoutParams mlp = (ViewGroup.MarginLayoutParams) v.getLayoutParams();
          mlp.topMargin = insets.top;
          mlp.leftMargin = insets.left;
          mlp.bottomMargin = insets.bottom;
          mlp.rightMargin = insets.right;
          v.setLayoutParams(mlp);

          // Return CONSUMED if you don't want want the window insets to keep passing
          // down to descendant views.
          return WindowInsetsCompat.CONSUMED;
        });

    startBtn = findViewById(R.id.start_button);
    changeBtn = findViewById(R.id.change_button);
    helpBtn = findViewById(R.id.help_button);
    languagesBtn = findViewById(R.id.languages_btn);

    final SharedPreferences sharedPreferences =
        getApplicationContext().getSharedPreferences("bibleNotify", MODE_PRIVATE);

    // Request exact alarm permission
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
      AlarmManager alarmManager =
          ContextCompat.getSystemService(MainActivity.this, AlarmManager.class);
      assert alarmManager != null;
      if (!alarmManager.canScheduleExactAlarms()) {
        // Show Dialog

        /* Make Alert dialog */
        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
        LayoutInflater inflater = MainActivity.this.getLayoutInflater();
        builder.setCancelable(false);
        View v_ = inflater.inflate(R.layout.permission_dialog, null);

        builder.setView(v_);
        builder.setTitle(MainActivity.this.getString(R.string.alarm_permission_dialog_title));
        builder
            // .setMessage("")
            .setPositiveButton(
                MainActivity.this.getString(R.string.allow_permission_btn),
                (dialog, id) -> {
                  // Get permission
                  Intent intent = new Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM);
                  intent.setData(Uri.fromParts("package", getPackageName(), null));
                  startActivity(intent);
                })
            .create()
            .show();
      }
    }

    // If enabled set image to done
    if (sharedPreferences.contains("Started")) {
      startBtn.setText(R.string.biblenotify_is_running);
      startBtn.setBackgroundColor(Color.BLACK);
      startBtn.setTextColor(Color.WHITE);
      MaterialButton MButton = (MaterialButton) startBtn;
      MButton.setStrokeColor(ColorStateList.valueOf(ContextCompat.getColor(this, R.color.black)));
      MButton.setIconTint(ColorStateList.valueOf(ContextCompat.getColor(this, R.color.black)));
    }

    // Auto set the language
    SharedPreferences.Editor editor = sharedPreferences.edit();
    if (!sharedPreferences.contains("languagePath")) {
      editor.putString("language", Locale.getDefault().getDisplayLanguage());
      editor.putString("languagePath", Locale.getDefault().getLanguage());
      editor.apply();
    }

    // Start Button
    startBtn.setOnClickListener(
        v -> {
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            checkNotificationPermission();
          }

          if (sharedPreferences.contains("Started")
              && sharedPreferences.getString("Started", "no").equals("yes")) {
            Toast.makeText(
                    getApplicationContext(),
                    MainActivity.this.getString(R.string.biblenotify_is_running),
                    Toast.LENGTH_SHORT)
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
                .setMessage(R.string.send_daily_notification_at)
                .setPositiveButton(
                    "ok",
                    (dialog, id) -> {
                      // Save the time
                      SharedPreferences.Editor editor1 = sharedPreferences.edit();
                      editor1.putInt("SetTimeH", hourToBeSaved);
                      editor1.putInt("SetTimeM", minToBeSaved);
                      editor1.apply();

                      SetAlarm.startAlarmBroadcastReceiver(MainActivity.this, sharedPreferences);
                      Toast.makeText(getApplicationContext(), "Saved", Toast.LENGTH_SHORT).show();

                      // Animation
                      startBtn.setText(R.string.biblenotify_is_running);
                      startBtn.setBackgroundColor(Color.BLACK);
                      startBtn.setTextColor(Color.WHITE);
                      MaterialButton MButton = (MaterialButton) startBtn;
                      MButton.setStrokeColor(
                          ColorStateList.valueOf(ContextCompat.getColor(this, R.color.black)));
                      MButton.setIconTint(
                          ColorStateList.valueOf(ContextCompat.getColor(this, R.color.black)));
                    })
                .setNeutralButton(
                    "Cancel",
                    (dialog, id) -> {
                      SharedPreferences.Editor editor12 = sharedPreferences.edit();
                      editor12.putString("Started", "No");
                      editor12.apply();
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

            // Set time

            // Get the currently set time from sharedPreferences
            if (sharedPreferences.getString("Started", "no").equals("yes")) {
              hourToSet = sharedPreferences.getInt("SetTimeH", 0);
              minToSet = sharedPreferences.getInt("SetTimeM", 0);
            }

            if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.LOLLIPOP_MR1) {
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
                    MainActivity.this.getString(R.string.start_sending_notifications_first_toast),
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

  @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
  void checkNotificationPermission() {
    int permissionState =
        ContextCompat.checkSelfPermission(this, android.Manifest.permission.POST_NOTIFICATIONS);
    // If the permission is not granted, request it.
    if (permissionState == PackageManager.PERMISSION_DENIED) {
      ActivityCompat.requestPermissions(
          this, new String[] {android.Manifest.permission.POST_NOTIFICATIONS}, 1);
    }
  }

  @Override
  protected void onResume() {
    super.onResume();
    // Check if the app can schedule exact alarms
    //    AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
    //    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
    // !alarmManager.canScheduleExactAlarms()) {
    //      // If not, request the SCHEDULE_EXACT_ALARM permission
    //      Toast.makeText(
    //              getApplicationContext(),
    //              "Permission for notifications needed on Android 14+",
    //              Toast.LENGTH_LONG)
    //          .show();
    //      Intent intent = new
    // Intent(android.provider.Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM);
    //      intent.setData(Uri.fromParts("package", getPackageName(), null));
    //      startActivity(intent);
    //    }
  }
}
