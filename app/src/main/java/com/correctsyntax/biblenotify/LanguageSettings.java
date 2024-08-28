package com.correctsyntax.biblenotify;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import androidx.appcompat.app.AppCompatActivity;
import java.util.HashMap;

public class LanguageSettings extends AppCompatActivity
    implements AdapterView.OnItemSelectedListener {

  Spinner languageSelector;
  HashMap<String, String> languages = new HashMap<String, String>();

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.language_settings);

    languageSelector = findViewById(R.id.language_selector);

    // ***********************
    // How to add a new language to Bible Notify:
    // 1. Add language name (i.e English, French) to language_choices.xml Like
    // `<item>English</item>`
    // 2. Add language to HashMap below (i.e `languages.put("English", "en");`)
    // 3. Create folder with language short hand as the name (i.e "en", "fr") in "assets/bible/"
    // (i.e "assets/bible/fr/")
    // 4. Put the Bible files in the language folder
    // ***********************

    // Add languages
    languages.put("English", "en");
    languages.put("Français", "fr");

    // Create an ArrayAdapter using the string array and a default spinner layout.
    ArrayAdapter<CharSequence> adapter =
        ArrayAdapter.createFromResource(
            this, R.array.language_array, android.R.layout.simple_spinner_item);
    // Specify the layout to use when the list of choices appears.
    adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
    // Apply the adapter to the spinner.
    languageSelector.setAdapter(adapter);
    languageSelector.setOnItemSelectedListener(this);

    final SharedPreferences sharedPreferences =
        getApplicationContext().getSharedPreferences("bibleNotify", MODE_PRIVATE);

    // set the spinner val
    languageSelector.setSelection(
        adapter.getPosition(sharedPreferences.getString("language", "en")));
  }

  public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {

    final SharedPreferences sharedPreferences =
        getApplicationContext().getSharedPreferences("bibleNotify", MODE_PRIVATE);

    // Log.d("++++++", (String) parent.getItemAtPosition(pos));

    SharedPreferences.Editor editor = sharedPreferences.edit();
    editor.putString("language", (String) parent.getItemAtPosition(pos));
    editor.putString("languagePath", languages.get((String) parent.getItemAtPosition(pos)));
    editor.apply();

    // An item is selected. You can retrieve the selected item using
    // parent.getItemAtPosition(pos).
  }

  public void onNothingSelected(AdapterView<?> parent) {
    // Another interface callback.
  }
}
