#!/usr/bin/env bash
# Run inside this folder. Needs Flutter SDK (flutter doctor must pass).
set -e
APP=private_ops_app
flutter create --org com.cyberpoka --project-name private_ops "$APP"
cp -r lib/. "$APP/lib/"
mkdir -p "$APP/assets" && cp -r assets/. "$APP/assets/"
cp pubspec.yaml "$APP/pubspec.yaml"
M="$APP/android/app/src/main/AndroidManifest.xml"
sed -i 's#<application#<uses-permission android:name="android.permission.INTERNET"/>\n    <application android:usesCleartextTraffic="true"#' "$M"
sed -i 's#android:label="private_ops"#android:label="Private Ops"#' "$M"
cd "$APP" && flutter pub get
echo "Done. Test: cd $APP && flutter run    Build APK: flutter build apk --release"
