package com.correctsyntax.biblenotify;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TimePicker;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class SettingsActivity extends AppCompatActivity {

  TimePicker timePicker;
  ImageButton help;
  Button cancel, saveButton;

  public static int hour = 12;
  public static int min = 0;

  public static int hourToSet = 12;
  public static int minToSet = 0;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.settings_activity);

    ConstraintLayout topbar = findViewById(R.id.settings_top_bar);

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

    timePicker = findViewById(R.id.time_picker);
    saveButton = findViewById(R.id.set_time_button);
    cancel = findViewById(R.id.cancel_button);
    help = findViewById(R.id.set_help_button);

    final SharedPreferences sharedPreferences =
        getApplicationContext().getSharedPreferences("bibleNotify", MODE_PRIVATE);

    // set time
    // get currently set time from sharedPreferences
    if (sharedPreferences.contains("Started")) {
      hourToSet = sharedPreferences.getInt("SetTimeH", 0);
      minToSet = sharedPreferences.getInt("SetTimeM", 0);
    }

    if (android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.LOLLIPOP_MR1) {
      timePicker.setCurrentHour(hourToSet);
      timePicker.setCurrentMinute(minToSet);
    } else {
      timePicker.setHour(hourToSet);
      timePicker.setMinute(minToSet);
    }

    // Time picker
    timePicker.setOnTimeChangedListener(
        (timePicker, h, m) -> {
          hour = h;
          min = m;
        });

    // Save Button
    saveButton.setOnClickListener(
        v -> {
          SharedPreferences.Editor editor = sharedPreferences.edit();
          editor.putInt("SetTimeH", hour);
          editor.putInt("SetTimeM", min);
          editor.commit();

          SetAlarm.startAlarmBroadcastReceiver(SettingsActivity.this, sharedPreferences);

          Toast.makeText(getApplicationContext(), R.string.time_saved_toast, Toast.LENGTH_SHORT)
              .show();
          finish();
        });

    // Cancel Button
    cancel.setOnClickListener(v -> finish());

    // Help
    help.setOnClickListener(
        v -> {
          Intent help_Intent = new Intent(SettingsActivity.this, HelpActivity.class);
          startActivity(help_Intent);
        });
  }
}
