# gen_code.ps1 - Windows
echo "Running flutter pub get..."
flutter pub get

echo "Generating localization files..."
flutter gen-l10n

echo "Running build_runner..."
dart run build_runner build --delete-conflicting-outputs

echo "Done!"
