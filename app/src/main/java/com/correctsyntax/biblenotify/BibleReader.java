package com.correctsyntax.biblenotify;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class BibleReader extends AppCompatActivity {

  TextView chapterText;
  WebView bibleTextWebView;
  ImageButton home;

  String languagePath = "en";

  @SuppressLint("SetJavaScriptEnabled")
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.reader_activity);

    ConstraintLayout topbar = findViewById(R.id.reader_top_bar);

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

    bibleTextWebView = findViewById(R.id.reader_webview);
    chapterText = findViewById(R.id.chapter_text);
    home = findViewById(R.id.home_button);

    bibleTextWebView.getSettings().setJavaScriptEnabled(true);

    // lang
    final SharedPreferences sharedPreferences =
        BibleReader.this.getSharedPreferences("bibleNotify", 0);
    languagePath = sharedPreferences.getString("languagePath", "en");

    // Go to home
    home.setOnClickListener(
        v -> {
          Intent back = new Intent(BibleReader.this, MainActivity.class);
          startActivity(back);
        });

    setText(
        pickFromBible(BibleReader.this, "text", "bible/" + languagePath + "/", ".json"),
        pickFromBible(BibleReader.this, "chapter", "bible/" + languagePath + "/", ".json"));
  }

  // Set the text
  public void setText(String bibleChapterText, String bibleChapter) {
    chapterText.setText(bibleChapter.toUpperCase());

    // Set Colors
    String appBlack = "black";
    String appDarkGray = "DimGray";
    String appLightGray = "Gainsboro";
    String appWhite = "white";

    // Check for dark mode and change colors to mach
    String backgroundColor = appWhite;
    String textColor = appDarkGray;
    String highlightColor = appBlack;

    int nightModeFlags =
        home.getContext().getResources().getConfiguration().uiMode
            & Configuration.UI_MODE_NIGHT_MASK;

    switch (nightModeFlags) {
      case Configuration.UI_MODE_NIGHT_YES:
        System.out.print("UI_MODE_NIGHT_YES");
        backgroundColor = appBlack;
        textColor = appLightGray;
        highlightColor = appWhite;
        break;

      case Configuration.UI_MODE_NIGHT_NO:
        System.out.print("UI_MODE_NIGHT_NO");
        backgroundColor = appWhite;
        textColor = appDarkGray;
        highlightColor = appBlack;
        break;

      case Configuration.UI_MODE_NIGHT_UNDEFINED:
        System.out.print("UI_MODE_NIGHT_UNDEFINED");
        backgroundColor = appWhite;
        textColor = appDarkGray;
        highlightColor = appBlack;
        break;
    }

    // Verse Highlighting
    final SharedPreferences sharedPreferences =
        BibleReader.this.getSharedPreferences("bibleNotify", MODE_PRIVATE);
    String readerDataVerseNumber = "";
    if (sharedPreferences.contains("readerDataVerseNumber")) {
      readerDataVerseNumber = sharedPreferences.getString("readerDataVerseNumber", "");
    }

    bibleChapterText =
        bibleChapterText.replace(
            "<p><sup>" + readerDataVerseNumber + "</sup>",
            "<p class='hv'><sup>" + readerDataVerseNumber + "</sup>");

    // WebView won't allow ids or hex numbers
    String html =
        "<!DOCTYPE html>\n"
            + "<html lang=\"en\">\n"
            + "  <head>\n"
            + "    <meta charset=\"UTF-8\" />\n"
            + "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />\n"
            + "    <title>app</title>\n"
            + "  </head>\n"
            + "  <body>\n"
            + "    <style>\n"
            + "      body {\n"
            + "        margin: 50px 10% 100px 10%;"
            + "        color:"
            + textColor
            + ";"
            + "        background-color:"
            + backgroundColor
            + ";"
            + "      }\n"
            + "      p {\n"
            + "        font-size: 18px;\n"
            + "        font-family:  'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;\n"
            + "        color:"
            + textColor
            + ";"
            + "        background-color:"
            + backgroundColor
            + ";"
            + "      }\n"
            + "      @media (min-width: 768px) {\n"
            + // 768px
            "        p {\n"
            + "          font-size: 19px;\n"
            + "        }\n"
            + "      }\n"
            + "      sup {\n"
            + "        font-weight: bold;\n"
            + "      }\n"
            + "      .hv{\n"
            + "color:"
            + highlightColor
            + ";"
            + "      font-weight: bold;"
            + "      }\n"
            + "    </style>"
            + bibleChapterText
            + "</body>\n"
            + "</html>";

    bibleTextWebView.loadData(html, "text/html", "UTF-8");
  }

  // Get The Bible Verse
  public String pickFromBible(Context context, String whichPart, String path, String extension) {
    String name = null;
    try {
      // get JSONObject from JSON file
      JSONObject obj = new JSONObject(loadJSONFromAsset(context, path, extension));

      // fetch JSONArray named users
      JSONArray userArray = obj.getJSONArray("read");

      try {
        JSONObject userDetail = userArray.getJSONObject(0);
        name = userDetail.getString(whichPart);

      } catch (JSONException e) {
        Toast.makeText(getApplicationContext(), R.string.error_toast, Toast.LENGTH_SHORT).show();
      }

    } catch (JSONException e) {
      Toast.makeText(getApplicationContext(), R.string.error_toast, Toast.LENGTH_SHORT).show();
    }

    return name;
  }

  public String loadJSONFromAsset(Context context, String path, String extension) {
    String json;
    String bookChapter = "book/ch";
    //  get value
    final SharedPreferences sharedPreferences =
        context.getSharedPreferences("bibleNotify", MODE_PRIVATE);

    if (sharedPreferences.contains("readerData")) {
      bookChapter = sharedPreferences.getString("readerData", "");
    }

    try {
      InputStream is = context.getAssets().open(path + bookChapter + extension);

      int size = is.available();
      byte[] buffer = new byte[size];
      is.read(buffer);
      is.close();
      json = new String(buffer, StandardCharsets.UTF_8);
    } catch (IOException ex) {
      return null;
    }
    return json;
  }
}
