package com.correctsyntax.biblenotify;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.content.Intent;
import android.net.Uri;

import android.app.AlertDialog;
import android.content.DialogInterface;


public class helpActivity extends Activity {

    Button back;
    TextView licenseLink, webPageLink;

    Intent intent = null, chooser = null, webIntent = null, webChooser = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.help_activity);

        back = findViewById(R.id.back_button_help);
        licenseLink = findViewById(R.id.license_link);
        webPageLink = findViewById(R.id.web_page_link);


        // Back
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        // license Link
        licenseLink.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                AlertDialog.Builder builder = new AlertDialog.Builder(helpActivity.this);
                builder.setTitle("Bible Notify License");
                builder.setMessage(R.string.license);
                builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        // User clicked OK button !!!
                    }
                });

                builder.setCancelable(true);
                final AlertDialog alert = builder.create();
                alert.show();
            }
        });
        // OUR Web Page Link
        webPageLink.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                webIntent = new Intent(Intent.ACTION_VIEW);
                webIntent.setData(Uri.parse("https://biblenotify.github.io"));
                webChooser=Intent.createChooser(webIntent,"View our website");
                startActivity(webChooser);

            }
        });


    }
}

