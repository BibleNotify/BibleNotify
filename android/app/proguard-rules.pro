# Prevent R8 from removing or renaming the notification plugin mapping classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep the main R class and ALL generated underlying sub-classes (like R$drawable)
-keep class **.R { *; }
-keep class **.R$* { *; }

# Prevent optimization from stripping internal naming fields mapping strings to IDs
-keepclassmembers class **.R$* {
    public static <fields>;
}
