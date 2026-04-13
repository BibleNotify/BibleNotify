# Adding a New Bible to Bible Notify

Create a new folder with the same folder and file structure as the other Bibles in ``assets/bibles/``

Add a value for the Bible to ``bibleTranslationOptions`` in ``lib/common/constants.dart`` 

Add a ``BibleTranslationOption`` value for the Bible in ``lib/common/enums.dart``.


In ``pubspec.yaml`` add the paths to the json files. Tip: You can do a find and replace on this file to replace ``<the_bible_code>`` with the actual Bible code (e.g: rkjv) that matches the folder name in the code below and copy it.

```yaml
flutter:
  ...

  assets:
    ...

    - assets/bibles/<the_bible_code>/Verses/
    - assets/bibles/<the_bible_code>/1Cor/
    - assets/bibles/<the_bible_code>/1Kgs/
    - assets/bibles/<the_bible_code>/1Thes/
    - assets/bibles/<the_bible_code>/1Tm/
    - assets/bibles/<the_bible_code>/2Chr/
    - assets/bibles/<the_bible_code>/2Cor/
    - assets/bibles/<the_bible_code>/Am/
    - assets/bibles/<the_bible_code>/Dt/
    - assets/bibles/<the_bible_code>/Eccl/
    - assets/bibles/<the_bible_code>/Ex/
    - assets/bibles/<the_bible_code>/Gal/
    - assets/bibles/<the_bible_code>/Gn/
    - assets/bibles/<the_bible_code>/Hb/
    - assets/bibles/<the_bible_code>/Heb/
    - assets/bibles/<the_bible_code>/Is/
    - assets/bibles/<the_bible_code>/Jas/
    - assets/bibles/<the_bible_code>/Jb/
    - assets/bibles/<the_bible_code>/Jer/
    - assets/bibles/<the_bible_code>/Jn/
    - assets/bibles/<the_bible_code>/Lk/
    - assets/bibles/<the_bible_code>/Mt/
    - assets/bibles/<the_bible_code>/Nm/
    - assets/bibles/<the_bible_code>/Phil/
    - assets/bibles/<the_bible_code>/Prv/
    - assets/bibles/<the_bible_code>/Ps/
    - assets/bibles/<the_bible_code>/Rom/
    - assets/bibles/<the_bible_code>/Rv/

    ...
```