package com.correctsyntax.biblenotify;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageButton;
import android.widget.TimePicker;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    ImageButton startBtn, changeBtn, helpBtn;

    Animation animFadeOut;

    public static int HourToSet = 12;
    public static int MinToSet = 0;

    public static int HourToBeSaved = 12;
    public static int MinToBeSaved = 0;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        startBtn = findViewById(R.id.start_button);
        changeBtn = findViewById(R.id.change_button);
        helpBtn = findViewById(R.id.help_button);

        final SharedPreferences sharedPreferences = getApplicationContext().getSharedPreferences("bibleNotify",MODE_PRIVATE);



// If enabled set image to done
        if(sharedPreferences.contains("Started")) {
            startBtn.setImageResource(R.drawable.ic_pause_sending_button);
        }


        // Start Button
        startBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(sharedPreferences.contains("Started") && sharedPreferences.getString("Started", "no").equals("yes")){
                    Toast.makeText(getApplicationContext(),"Bible Notify is running",Toast.LENGTH_SHORT).show();
                }else{
                    // tell that it has been enabled
                    SharedPreferences.Editor editor = sharedPreferences.edit();
                    editor.putString("Started", "yes");
                    editor.commit();


                    /* Make Alert dialog */
                    AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
                    LayoutInflater inflater = MainActivity.this.getLayoutInflater();
                    builder.setCancelable(false);
                    View v_ = inflater.inflate(R.layout.start_dialog, null);
                    builder.setView(v_);
                    builder.setTitle("Set Time");
                    builder.setMessage("Send notification at:")
                            .setPositiveButton("ok", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int id) {
                                    // save time
                                    SharedPreferences.Editor editor = sharedPreferences.edit();
                                    editor.putInt("SetTimeH", HourToBeSaved);
                                    editor.putInt("SetTimeM", MinToBeSaved);
                                    editor.commit();

                                    SetAlarm.startAlarmBroadcastReceiver(MainActivity.this, sharedPreferences);
                                    Toast.makeText(getApplicationContext(),"Saved",Toast.LENGTH_SHORT).show();

                                    // Animation
                                    animFadeOut = AnimationUtils.loadAnimation(getApplicationContext(),R.anim.fade_out);
                                    startBtn.setVisibility(View.VISIBLE);
                                    startBtn.startAnimation(animFadeOut);
                                    startBtn.setImageResource(R.drawable.ic_pause_sending_button);

                                }
                            })
                            .setNeutralButton("Cancel", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int id) {
                                    SharedPreferences.Editor editor = sharedPreferences.edit();
                                    editor.putString("Started", "No");
                                    editor.commit();
                                }
                            }).create().show();
                    // get time picker object
                    TimePicker input = v_.findViewById(R.id.start_time_picker);

                    // set event Listener on Time picker
                    input.setOnTimeChangedListener(new TimePicker.OnTimeChangedListener() {
                        @Override
                        public void onTimeChanged(TimePicker timePicker, int H, int M) {
                            HourToBeSaved = H;
                            MinToBeSaved = M;
                        }

                    });


                    // set time

                    // get currently set time from sharedPreferences
                    if(sharedPreferences.getString("Started", "no").equals("yes")) {
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


                }

            }
        });


        // Settings (Change time)
        changeBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(sharedPreferences.contains("Started") && sharedPreferences.getString("Started", "no").equals("yes")){
                    Intent settings_Intent = new Intent(MainActivity.this, SettingsActivity.class);
                    startActivity(settings_Intent);
                }else {
                    Toast.makeText(getApplicationContext(),"You must start sending notifications first",Toast.LENGTH_LONG).show();
                }

            }
        });

        // Help
        helpBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent help_Intent=new Intent(MainActivity.this, HelpActivity.class);
                startActivity(help_Intent);
            }
        });












    }






}