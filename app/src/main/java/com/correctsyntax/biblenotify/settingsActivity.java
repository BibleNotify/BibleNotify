package com.correctsyntax.biblenotify;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TimePicker;
import android.widget.Toast;
import android.widget.ImageButton;
import android.content.SharedPreferences;

public class settingsActivity extends Activity {

    TimePicker input;
    Button saveButton;
    ImageButton back;

    public static int Hour = 12;
    public static int Min = 0;

    public static int HourToSet = 12;
    public static int MinToSet = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.settings_activity);
        input = findViewById(R.id.input);
        saveButton = findViewById(R.id.savebutton);
        back = findViewById(R.id.back_button);

        final SharedPreferences sharedPreferences = getApplicationContext().getSharedPreferences("bibleNotify",MODE_PRIVATE);



        // set time

        // get currently set time from sharedPreferences
        if(sharedPreferences.contains("Started")) {
            HourToSet = sharedPreferences.getInt("SetTimeH", 0);
            MinToSet = sharedPreferences.getInt("SetTimeM", 0);
        }

        if (android.os.Build.VERSION.SDK_INT  <= android.os.Build.VERSION_CODES.LOLLIPOP_MR1) {
            input.setCurrentHour(HourToSet);
            input.setCurrentMinute(MinToSet);
        }else{
            input.setHour(HourToSet);
            input.setMinute(MinToSet);
        }

        // Time picker
        input.setOnTimeChangedListener(new TimePicker.OnTimeChangedListener() {
            @Override
            public void onTimeChanged(TimePicker timePicker, int H, int M) {
                Hour = H;
                Min = M;
            }

        });

        // Save Button
        saveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SharedPreferences.Editor editor = sharedPreferences.edit();
                editor.putInt("SetTimeH", Hour);
                editor.putInt("SetTimeM", Min);
                editor.commit();

                setAlarm.startAlarmBroadcastReceiver(settingsActivity.this, sharedPreferences);

                Toast.makeText(getApplicationContext(),"Saved",Toast.LENGTH_SHORT).show();

            }
        });

        // Back Button
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();

            }
        });


    }


}


