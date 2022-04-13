package com.correctsyntax.biblenotify;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.webkit.WebView;
import android.widget.ImageButton;
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

    TextView chapterText;
    WebView bibleTextWebView;
    ImageButton home;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.reader_activity);


        bibleTextWebView = findViewById(R.id.reader_webview);
        chapterText = findViewById(R.id.chapter_text);
        home = findViewById(R.id.home_button);

        bibleTextWebView.getSettings().setJavaScriptEnabled(true);


        // Go to home
        home.setOnClickListener(v -> {
            Intent back = new Intent(BibleReader.this, MainActivity.class);
            startActivity(back);

        });

        setText(pickFromBible(BibleReader.this, "text", "bible/", ".json"), pickFromBible(BibleReader.this, "chapter", "bible/", ".json"));

    }

    // Set the text
    public void setText(String bibleChapterText, String bibleChapter){
        chapterText.setText(bibleChapter.toUpperCase());

        String html = "<html> <p>" + bibleChapterText + "</p> </html>";


        bibleTextWebView.loadData(html, "text/html", "UTF-8");



    }



    // Get The Bible Verse
    public String pickFromBible(Context context, String whichPart, String pathOne, String pathTwo) {
        String name = null;
        try {
            // get JSONObject from JSON file
            JSONObject obj = new JSONObject(loadJSONFromAsset(context, pathOne, pathTwo));

            // fetch JSONArray named users
            JSONArray userArray = obj.getJSONArray("read");

            try {
                JSONObject userDetail = userArray.getJSONObject(0);
                name = userDetail.getString(whichPart);

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
        String json;
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















