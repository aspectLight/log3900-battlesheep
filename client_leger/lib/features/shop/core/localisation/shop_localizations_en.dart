// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'shop_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ShopLocalizationsEn extends ShopLocalizations {
  ShopLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get shopTitle => 'Shop';

  @override
  String get shopBack => 'Home page';

  @override
  String get shopBannersSection => 'Banners';

  @override
  String get shopCharactersSection => 'Exclusive characters';

  @override
  String get shopAvatarsSection => 'Exclusive avatars';

  @override
  String get shopBuy => 'Buy';

  @override
  String get shopOwned => 'Owned';

  @override
  String get shopEquip => 'Equip';

  @override
  String get shopUnequip => 'Unequip';

  @override
  String get shopPurchaseSuccess => 'Purchase successful!';

  @override
  String get shopEquipped => 'Cosmetic equipped!';

  @override
  String get shopUnequipped => 'Cosmetic unequipped.';

  @override
  String get shopPurchaseFailedTitle => 'Purchase failed';

  @override
  String get shopPurchaseFailedInsufficientFunds =>
      'You don\'t have enough coins to buy this item.';

  @override
  String get shopPurchaseFailedAlreadyPurchased => 'You already own this item.';

  @override
  String get shopPurchaseFailedItemNotFound =>
      'This item is not available in the shop.';

  @override
  String get shopPurchaseFailedNotAuthenticated =>
      'You must be signed in to make a purchase.';

  @override
  String get shopPurchaseFailedUnknown =>
      'Your purchase could not be completed. Please try again.';

  @override
  String get shopBannerPreviewPlayer => 'Player';

  @override
  String get shopBannerPreviewHp => 'HP';

  @override
  String get shopBannerPreviewSpeed => 'Speed';

  @override
  String get shopBannerPreviewAttack => 'Attack';

  @override
  String get shopBannerPreviewDefense => 'Defense';
}
