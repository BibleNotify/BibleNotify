<div align="center">
  <img src=".assets/illustration.svg" />
  <h1>Bible Notify</h1>
  <p>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPL_v3-green.svg" /></a>
  </p>
  <p>Daily Scripture Verse Notifications for Android devices.</p>
  <p><i>Thy word is a lamp unto my feet, and a light unto my path." -Psalms 119:105</i></p>
</div>


## What Is Bible Notify?

Bible Notify is a free, daily Bible verse notification application for Android devices. Get daily Bible verse notifications from your mobile device with the free & open-source Bible Notify app and meditate on the Scriptures. 

[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png"
     alt="Get it on F-Droid"
     height="80">](https://f-droid.org/packages/com.correctsyntax.biblenotify/)

[<img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
     alt="Get it on Google Play"
     height="80">](https://play.google.com/store/apps/details?id=com.biblenotify.biblenotify)

Please note that the application package name is different on Google Play than other app stores and the apk in releases.


## Desktop Version

Get [Bible Notify Desktop](https://github.com/BibleNotify/BibleNotifyDesktop), a desktop version of Bible Notify for Linux, Windows, and macOS.


## Element Chat

Need help? Want to help out? [Join our Element chat](https://matrix.to/#/#bible-notify:matrix.org) to chat with the developers or get support.


## Running the Code

Open the project in Android Studio and sync Gradle. Bible Notify uses minimal dependencies.


## Contributing

Contributions are always welcome! Feel free to open a PR or ask questions.


## Release Process

- [ ] Update ``versionName`` in ``build.gradle``.
- [ ] Update ``versonCode`` to +1 of the previous number in ``build.gradle``.
- [ ] Build a signed apk ``com.correctsyntax.biblenotify`` by choosing the ``otherStoresRelease`` Build Variant in Android Studio.
- [ ] Write release notes and create new GitHub release with built apk attached.

For the Google Play version since it has a different package name:
- [ ] Build a signed appbundle ``com.biblenotify.biblenotify`` by choosing the ``googlePlayRelease`` Build Variant in Android Studio.
- [ ] Create new release and upload the appbundle to Google Play.


## License

Bible Notify is licensed under the GPL-3.0 License.

The French text used in this app is the [AELF](https://www.aelf.org/) translation. Please [contact them](https://www.aelf.org/contact) for any question or inquiry.

The Arabic text used in this app is the [SVD Translation](https://st-takla.org/) provided by The Coptic Orthodox Church with a free license.
