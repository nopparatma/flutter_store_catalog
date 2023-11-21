#!/bin/bash

APP_NAME="store_catalog"
EXPORT_FLAVOR="prd_homepro"

flutter clean

# for canvaskit offline
# current 0.25.1
# every upgrading flutter version - please check canvaskit url  https://unpkg.com/canvaskit-wasm@0.25.1/bin/canvaskit.js
#flutter run -d chrome --release -t "lib/main_${EXPORT_FLAVOR}.dart"
#flutter build web --release -t "lib/main_${EXPORT_FLAVOR}.dart" --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/ -v

#flutter run -d chrome --web-renderer html --release -t "lib/main_${EXPORT_FLAVOR}.dart"
flutter build web --release --web-renderer html -t "lib/main_${EXPORT_FLAVOR}.dart" -v

cd build/web
sed -i '' "s/main.dart.js/main.dart.js?v=$(date +%Y%m%d%H%M%S)/g" index.html
sed -i '' "s/version.json/version.json?v=$(date +%Y%m%d%H%M%S)/g" index.html
sed -i '' "s/langs.csv/langs.csv?v=$(date +%Y%m%d%H%M%S)/g" index.html