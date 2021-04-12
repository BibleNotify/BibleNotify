package com.correctsyntax.biblenotify;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.View;
import android.widget.ImageButton;
import android.widget.Toast;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.content.SharedPreferences;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.view.LayoutInflater;
import android.widget.TimePicker;
import com.correctsyntax.biblenotify.setAlarm;


public class MainActivity extends Activity {

    ImageButton btnstart, btnsettings, btnhelp;
    Animation animFadeOut;

    public static int MainSetTimeInt = 24;
    public static int minTime = 60;

    public static int min = 0;
    public static int hour = 12;

    public static int HourToSet = 12;
    public static int MinToSet = 0;

    public static int HourToBeSaved = 12;
    public static int MinToBeSaved = 0;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btnstart= findViewById(R.id.start_button);
        btnsettings = findViewById(R.id.settings_button);
        btnhelp = findViewById(R.id.help_button);


        final SharedPreferences sharedPreferences = getApplicationContext().getSharedPreferences("bibleNotify",MODE_PRIVATE);

        // If enabled set image to done
        if(sharedPreferences.contains("Started")) {
            btnstart.setImageResource(R.drawable.start_button_two);
        }

        // Start Button
        btnstart.setOnClickListener(new View.OnClickListener() {
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
                    builder.setCancelable(true);
                    View v_ = inflater.inflate(R.layout.dialog, null);
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

                                    setAlarm.startAlarmBroadcastReceiver(MainActivity.this, sharedPreferences);
                                    Toast.makeText(getApplicationContext(),"Saved",Toast.LENGTH_SHORT).show();

                                    // Animation
                                    animFadeOut = AnimationUtils.loadAnimation(getApplicationContext(),R.anim.fade_out);
                                    btnstart.setVisibility(View.VISIBLE);
                                    btnstart.startAnimation(animFadeOut);
                                    btnstart.setImageResource(R.drawable.start_button_two);

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
                    TimePicker input = v_.findViewById(R.id.picktime);

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


        // Settings
        btnsettings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent settings_Intent=new Intent(MainActivity.this,settingsActivity.class);
                startActivity(settings_Intent);

            }
        });

        // Help
        btnhelp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent help_Intent=new Intent(MainActivity.this,helpActivity.class);
                startActivity(help_Intent);
            }
        });



    }
}