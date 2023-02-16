package com.correctsyntax.biblenotify;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.widget.ImageButton;
import android.widget.TimePicker;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

public class SettingsActivity extends AppCompatActivity {

    TimePicker timePicker;
    ImageButton cancel, saveButton, help;

    public static int Hour = 12;
    public static int Min = 0;

    public static int HourToSet = 12;
    public static int MinToSet = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.settings_activity);

        timePicker = findViewById(R.id.time_picker);
        saveButton = findViewById(R.id.set_time_button);
        cancel = findViewById(R.id.cancel_button);
        help = findViewById(R.id.set_help_button);


        final SharedPreferences sharedPreferences = getApplicationContext().getSharedPreferences("bibleNotify",MODE_PRIVATE);

        // set time
        // get currently set time from sharedPreferences
        if(sharedPreferences.contains("Started")) {
            HourToSet = sharedPreferences.getInt("SetTimeH", 0);
            MinToSet = sharedPreferences.getInt("SetTimeM", 0);
        }

        if (android.os.Build.VERSION.SDK_INT  <= android.os.Build.VERSION_CODES.LOLLIPOP_MR1) {
            timePicker.setCurrentHour(HourToSet);
            timePicker.setCurrentMinute(MinToSet);
        }else{
            timePicker.setHour(HourToSet);
            timePicker.setMinute(MinToSet);
        }

        // Time picker
        timePicker.setOnTimeChangedListener((timePicker, H, M) -> {
            Hour = H;
            Min = M;
        });

        // Save Button
        saveButton.setOnClickListener(v -> {
            SharedPreferences.Editor editor = sharedPreferences.edit();
            editor.putInt("SetTimeH", Hour);
            editor.putInt("SetTimeM", Min);
            editor.commit();

            SetAlarm.startAlarmBroadcastReceiver(SettingsActivity.this, sharedPreferences);

            Toast.makeText(getApplicationContext(),"Saved",Toast.LENGTH_SHORT).show();
            finish();
        });

        // Cancel Button
        cancel.setOnClickListener(v -> finish());

        // Help
        help.setOnClickListener(v -> {
            Intent help_Intent=new Intent(SettingsActivity.this, HelpActivity.class);
            startActivity(help_Intent);
        });


    }

}
