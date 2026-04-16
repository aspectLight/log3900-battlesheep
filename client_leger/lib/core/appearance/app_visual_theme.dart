import '../constants/ui_assets.dart';

enum AppVisualTheme { defaultTheme, frost, village }

const String kThemeIdDefault = 'default';
const String kThemeIdFrost = 'frost';
const String kThemeIdVillage = 'village';

AppVisualTheme appVisualThemeFromId(String? raw) {
  switch (raw) {
    case kThemeIdFrost:
      return AppVisualTheme.frost;
    case kThemeIdVillage:
      return AppVisualTheme.village;
    case kThemeIdDefault:
    default:
      return AppVisualTheme.defaultTheme;
  }
}

String appVisualThemeToId(AppVisualTheme theme) {
  switch (theme) {
    case AppVisualTheme.frost:
      return kThemeIdFrost;
    case AppVisualTheme.village:
      return kThemeIdVillage;
    case AppVisualTheme.defaultTheme:
      return kThemeIdDefault;
  }
}

/// Parallax background image for the active visual theme.
String backgroundAssetForVisualTheme(AppVisualTheme theme) {
  switch (theme) {
    case AppVisualTheme.frost:
      return UiAssets.backgroundFrost;
    case AppVisualTheme.village:
      return UiAssets.backgroundVillage;
    case AppVisualTheme.defaultTheme:
      return UiAssets.background;
  }
}
