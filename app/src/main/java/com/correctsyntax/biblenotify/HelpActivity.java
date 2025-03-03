package com.correctsyntax.biblenotify;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

public class HelpActivity extends AppCompatActivity {

  Button back;
  TextView licenseLink;
  TextView webPageLink;
  Intent webIntent = null;
  Intent webChooser = null;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.help_activity);

    back = findViewById(R.id.close_help_button);
    licenseLink = findViewById(R.id.view_license_button);
    webPageLink = findViewById(R.id.website_link);

    // Back
    back.setOnClickListener(v -> finish());
    // License link
    licenseLink.setOnClickListener(
        v -> {
          AlertDialog.Builder builder = new AlertDialog.Builder(HelpActivity.this);
          builder.setTitle(R.string.biblenotify_license);
          builder.setMessage(R.string.license);
          builder.setPositiveButton(
              R.string.close_btn,
              (dialog, id) -> {
                // User tapped the button
              });

          builder.setCancelable(true);
          final AlertDialog alert = builder.create();
          alert.show();
        });

    // Website link
    webPageLink.setOnClickListener(
        v -> {
          webIntent = new Intent(Intent.ACTION_VIEW);
          webIntent.setData(Uri.parse("https://biblenotify.github.io"));
          webChooser =
              Intent.createChooser(
                  webIntent, HelpActivity.this.getString(R.string.visit_our_website));
          startActivity(webChooser);
        });
  }
}
