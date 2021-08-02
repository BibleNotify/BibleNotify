package com.correctsyntax.biblenotify;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.content.Context;
import android.content.Intent;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

import android.content.SharedPreferences;
import android.widget.TextView;
import android.widget.ImageButton;
import android.view.View;
import android.widget.Toast;
import android.widget.ScrollView;

public class bibleReader extends Activity {
    TextView mainTextHold, verseText;
    ImageButton home;
    ScrollView scrollview;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.reader_activity);

        mainTextHold = findViewById(R.id.main_text);
        verseText = findViewById(R.id.verse_text);
        home = findViewById(R.id.back_button_read);
        scrollview = findViewById(R.id.scroll_text);



        // set padding
        int width = getResources().getDisplayMetrics().widthPixels;

        // when smaller then 500 px
        if(width <= 500){
            scrollview.setPadding(5,0,5,0);
            mainTextHold.setPadding(8,8,8,8);
            mainTextHold.setTextSize(20);
        }

        // When between 500 px and 1100 px
        if(width > 500 && width <= 1100){
            scrollview.setPadding(30,0,30,0);
            mainTextHold.setPadding(20,20,20,20);
            mainTextHold.setTextSize(22);
        }

        // when more then 1100 px
        if(width > 1101){
            scrollview.setPadding(35,0,35,0);
            mainTextHold.setPadding(30,30,30,30);
            mainTextHold.setTextSize(25);
        }



        // Go to home
        home.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent tohome = new Intent(bibleReader.this, MainActivity.class);
                startActivity(tohome);

            }
        });


            setText(pickFromBible(bibleReader.this, "text", "bible/", ".json"), pickFromBible(bibleReader.this, "chapter", "bible/", ".json"));


    }

    // Set the text
    public void setText(String bibleText, String bibleChapter){
            mainTextHold.setText(bibleText);
            verseText.setText(bibleChapter.toUpperCase());
    }


    // Get The Bible Verse
    public String pickFromBible(Context context, String whichpart, String pathOne, String pathTwo) {
        String name = null;
        try {
            // get JSONObject from JSON file
            JSONObject obj = new JSONObject(loadJSONFromAsset(context, pathOne, pathTwo));

            // fetch JSONArray named users
            JSONArray userArray = obj.getJSONArray("read");

            try {
                JSONObject userDetail = userArray.getJSONObject(0);
                name = userDetail.getString(whichpart);

            }catch (JSONException e){
                Toast.makeText(getApplicationContext(),"Bible Notify has encountered an error.",Toast.LENGTH_SHORT).show();
            }

        }
        catch (JSONException e) {
            Toast.makeText(getApplicationContext(),"Bible Notify has encountered an error.",Toast.LENGTH_SHORT).show();

        }

        return name;

    }


    public String loadJSONFromAsset(Context context, String partOne, String partTwo) {
        String json = null;
        String path = "book/ch";
        //  get value
        final SharedPreferences sharedPreferences = context.getSharedPreferences("bibleNotify",MODE_PRIVATE);

        if (sharedPreferences.contains("readerData")) {
            path = sharedPreferences.getString("readerData", "");
        }


        try {

            InputStream is = context.getAssets().open(partOne + path + partTwo);

            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                json = new String(buffer, StandardCharsets.UTF_8);
            }else{
                json = new String(buffer, Charset.forName("UTF-8"));
            }
        } catch (IOException ex) {
            return null;
        }
        return json;
    }

}




