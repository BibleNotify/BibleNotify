package com.correctsyntax.biblenotify;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
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

        // Set Colors
        String AppBlack = "black";
        String AppWhite = "white";

        // Check for dark mode and change colors to mach
        String backgroundColor = AppWhite;
        String textColor = AppBlack;


        int nightModeFlags = home.getContext().getResources().getConfiguration().uiMode &
                        Configuration.UI_MODE_NIGHT_MASK;

        switch (nightModeFlags) {
            case Configuration.UI_MODE_NIGHT_YES:
                System.out.print("UI_MODE_NIGHT_YES");
                backgroundColor = AppBlack;
                textColor = AppWhite;
                break;

            case Configuration.UI_MODE_NIGHT_NO:
                System.out.print("UI_MODE_NIGHT_NO");
                backgroundColor = AppWhite;
                textColor = AppBlack;
                break;

            case Configuration.UI_MODE_NIGHT_UNDEFINED:
                System.out.print("UI_MODE_NIGHT_UNDEFINED");
                backgroundColor = AppWhite;
                textColor = AppBlack;
                break;
        }


        // Verse Highlighting
        final SharedPreferences sharedPreferences = BibleReader.this.getSharedPreferences("bibleNotify",MODE_PRIVATE);
       String readerDataVerseNumber = "";
        if (sharedPreferences.contains("readerDataVerseNumber")) {
            readerDataVerseNumber = sharedPreferences.getString("readerDataVerseNumber", "");
        }

        bibleChapterText = bibleChapterText.replace("<p><sup>" + readerDataVerseNumber + "</sup>", "<p class='hv'><sup>" + readerDataVerseNumber + "</sup>");


        String html = "<!DOCTYPE html>\n" +
                "<html lang=\"en\">\n" +
                "  <head>\n" +
                "    <meta charset=\"UTF-8\" />\n" +
                "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />\n" +
                "    <title>app</title>\n" +
                "  </head>\n" +
                "  <body>\n" +
                "    <style>\n" +
                "      body {\n" +
                "        margin: 50px 10% 100px 10%;" +
                "        color:" + textColor + ";" +
                "        background-color:" + backgroundColor + ";" +
                "      }\n" +
                "      p {\n" +
                "        font-size: 18px;\n" +
                "        font-family:  'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;\n" +
                "        color:" + textColor + ";" +
                "        background-color:" + backgroundColor + ";" +
                "      }\n" +
                "      @media (min-width: 768px) {\n" + //768px
                "        p {\n" +
                "          font-size: 19px;\n" +
                "        }\n" +
                "      }\n" +
                "      sup {\n" +
                "        font-weight: bold;\n" +
                "      }\n" +
                "      .hv{\n" + // WebView won't allow ids
                "      border-left-style: solid;\n" +
                "      padding-left: 12px;\n" +
                "      border-left-width: 3px;\n" +
                "      border-left-color: LightGreen;\n" + //#43A047 WebView won't take hex numbers
                "      }\n" +
                "    </style>" +
                bibleChapterText +
                "</body>\n" +
                "</html>";


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















