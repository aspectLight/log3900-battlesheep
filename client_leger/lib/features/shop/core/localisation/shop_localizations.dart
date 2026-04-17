import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'shop_localizations_en.dart';
import 'shop_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ShopLocalizations
/// returned by `ShopLocalizations.of(context)`.
///
/// Applications need to include `ShopLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/shop_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ShopLocalizations.localizationsDelegates,
///   supportedLocales: ShopLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the ShopLocalizations.supportedLocales
/// property.
abstract class ShopLocalizations {
  ShopLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ShopLocalizations? of(BuildContext context) {
    return Localizations.of<ShopLocalizations>(context, ShopLocalizations);
  }

  static const LocalizationsDelegate<ShopLocalizations> delegate =
      _ShopLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopTitle;

  /// No description provided for @shopBack.
  ///
  /// In en, this message translates to:
  /// **'Home page'**
  String get shopBack;

  /// No description provided for @shopBannersSection.
  ///
  /// In en, this message translates to:
  /// **'Banners'**
  String get shopBannersSection;

  /// No description provided for @shopCharactersSection.
  ///
  /// In en, this message translates to:
  /// **'Exclusive characters'**
  String get shopCharactersSection;

  /// No description provided for @shopAvatarsSection.
  ///
  /// In en, this message translates to:
  /// **'Exclusive avatars'**
  String get shopAvatarsSection;

  /// No description provided for @shopBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get shopBuy;

  /// No description provided for @shopOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get shopOwned;

  /// No description provided for @shopEquip.
  ///
  /// In en, this message translates to:
  /// **'Equip'**
  String get shopEquip;

  /// No description provided for @shopUnequip.
  ///
  /// In en, this message translates to:
  /// **'Unequip'**
  String get shopUnequip;

  /// No description provided for @shopPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful!'**
  String get shopPurchaseSuccess;

  /// No description provided for @shopEquipped.
  ///
  /// In en, this message translates to:
  /// **'Cosmetic equipped!'**
  String get shopEquipped;

  /// No description provided for @shopUnequipped.
  ///
  /// In en, this message translates to:
  /// **'Cosmetic unequipped.'**
  String get shopUnequipped;

  /// Shown when updating the equipped banner preference fails unexpectedly.
  String get shopBannerPreferenceUpdateFailed;

  /// No description provided for @shopPurchaseFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get shopPurchaseFailedTitle;

  /// No description provided for @shopPurchaseFailedInsufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough coins to buy this item.'**
  String get shopPurchaseFailedInsufficientFunds;

  /// No description provided for @shopPurchaseFailedAlreadyPurchased.
  ///
  /// In en, this message translates to:
  /// **'You already own this item.'**
  String get shopPurchaseFailedAlreadyPurchased;

  /// No description provided for @shopPurchaseFailedItemNotFound.
  ///
  /// In en, this message translates to:
  /// **'This item is not available in the shop.'**
  String get shopPurchaseFailedItemNotFound;

  /// No description provided for @shopPurchaseFailedNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'You must be signed in to make a purchase.'**
  String get shopPurchaseFailedNotAuthenticated;

  /// No description provided for @shopPurchaseFailedUnknown.
  ///
  /// In en, this message translates to:
  /// **'Your purchase could not be completed. Please try again.'**
  String get shopPurchaseFailedUnknown;

  /// No description provided for @shopBannerPreviewPlayer.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get shopBannerPreviewPlayer;

  /// No description provided for @shopBannerPreviewHp.
  ///
  /// In en, this message translates to:
  /// **'HP'**
  String get shopBannerPreviewHp;

  /// No description provided for @shopBannerPreviewSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get shopBannerPreviewSpeed;

  /// No description provided for @shopBannerPreviewAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get shopBannerPreviewAttack;

  /// No description provided for @shopBannerPreviewDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get shopBannerPreviewDefense;

  String get bannerGold;

  String get bannerShadow;

  String get bannerFlame;

  String get bannerIce;

  String get bannerNeon;
}

class _ShopLocalizationsDelegate
    extends LocalizationsDelegate<ShopLocalizations> {
  const _ShopLocalizationsDelegate();

  @override
  Future<ShopLocalizations> load(Locale locale) {
    return SynchronousFuture<ShopLocalizations>(
      lookupShopLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_ShopLocalizationsDelegate old) => false;
}

ShopLocalizations lookupShopLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ShopLocalizationsEn();
    case 'fr':
      return ShopLocalizationsFr();
  }

  throw FlutterError(
    'ShopLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
