package com.correctsyntax.biblenotify;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

public class BibleReader extends AppCompatActivity {

    TextView bibleText, chapterText;
    ImageButton home;
    ScrollView scrollview;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.reader_activity);


            bibleText = findViewById(R.id.bible_text);
            chapterText = findViewById(R.id.chapter_text);
            home = findViewById(R.id.home_button);
            scrollview = findViewById(R.id.bible_text_scrollView);

            // set padding
            int width = getResources().getDisplayMetrics().widthPixels;

            // when smaller then 500 px
            if(width <= 500){
                scrollview.setPadding(5,0,5,0);
                bibleText.setPadding(8,8,8,8);
                bibleText.setTextSize(20);
            }

            // When between 500 px and 1100 px
            if(width > 500 && width <= 1100){
                scrollview.setPadding(30,0,30,0);
                bibleText.setPadding(20,20,20,20);
                bibleText.setTextSize(22);
            }

            // when more then 1100 px
            if(width > 1101){
                scrollview.setPadding(35,0,35,0);
                bibleText.setPadding(30,30,30,30);
                bibleText.setTextSize(25);
            }

            // Go to home
            home.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent back = new Intent(BibleReader.this, MainActivity.class);
                    startActivity(back);

                }
            });

            setText(pickFromBible(BibleReader.this, "text", "bible/", ".json"), pickFromBible(BibleReader.this, "chapter", "bible/", ".json"));

        }

        // Set the text
        public void setText(String bibleChapterText, String bibleChapter){
            bibleText.setText(bibleChapterText);
            chapterText.setText(bibleChapter.toUpperCase());
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







