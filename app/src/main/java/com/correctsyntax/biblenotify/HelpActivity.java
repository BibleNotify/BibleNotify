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
    TextView licenseLink, webPageLink;
    Intent webIntent = null, webChooser = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.help_activity);

        back = findViewById(R.id.close_help_button);
        licenseLink = findViewById(R.id.view_license_button);
        webPageLink = findViewById(R.id.website_link);

        // Back
        back.setOnClickListener(v -> finish());
        // license Link
        licenseLink.setOnClickListener(v -> {
            AlertDialog.Builder builder = new AlertDialog.Builder(HelpActivity.this);
            builder.setTitle("Bible Notify License");
            builder.setMessage(R.string.license);
            builder.setPositiveButton("close", (dialog, id) -> {
                // User clicked OK button !!!
            });

            builder.setCancelable(true);
            final AlertDialog alert = builder.create();
            alert.show();
        });

        // OUR Web Page Link
        webPageLink.setOnClickListener(v -> {
            webIntent = new Intent(Intent.ACTION_VIEW);
            webIntent.setData(Uri.parse("https://biblenotify.github.io"));
            webChooser=Intent.createChooser(webIntent,"View our website");
            startActivity(webChooser);

        });


    }


}
