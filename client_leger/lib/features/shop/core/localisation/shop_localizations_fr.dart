// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'shop_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class ShopLocalizationsFr extends ShopLocalizations {
  ShopLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get shopTitle => 'Boutique';

  @override
  String get shopBack => 'Page d\'accueil';

  @override
  String get shopBannersSection => 'Bannières';

  @override
  String get shopCharactersSection => 'Personnages exclusifs';

  @override
  String get shopAvatarsSection => 'Avatars exclusifs';

  @override
  String get shopBuy => 'Acheter';

  @override
  String get shopOwned => 'Possédé';

  @override
  String get shopEquip => 'Équiper';

  @override
  String get shopUnequip => 'Déséquiper';

  @override
  String get shopPurchaseSuccess => 'Achat effectué !';

  @override
  String get shopEquipped => 'Cosmétique équipé !';

  @override
  String get shopUnequipped => 'Cosmétique déséquipé.';

  @override
  String get shopPurchaseFailedTitle => 'Échec de l\'achat';

  @override
  String get shopPurchaseFailedInsufficientFunds =>
      'Vous n\'avez pas assez de pièces pour acheter cet article.';

  @override
  String get shopPurchaseFailedAlreadyPurchased =>
      'Vous possédez déjà cet article.';

  @override
  String get shopPurchaseFailedItemNotFound =>
      'Cet article est introuvable dans la boutique.';

  @override
  String get shopPurchaseFailedNotAuthenticated =>
      'Vous devez être connecté pour effectuer un achat.';

  @override
  String get shopPurchaseFailedUnknown =>
      'Votre achat n\'a pas pu être effectué. Veuillez réessayer.';

  @override
  String get shopBannerPreviewPlayer => 'Joueur';

  @override
  String get shopBannerPreviewHp => 'Vie';

  @override
  String get shopBannerPreviewSpeed => 'Rapidité';

  @override
  String get shopBannerPreviewAttack => 'Attaque';

  @override
  String get shopBannerPreviewDefense => 'Défense';

  @override
  String get bannerGold => 'Bannière dorée';

  @override
  String get bannerShadow => 'Bannière sombre';

  @override
  String get bannerFlame => 'Bannière flamme';

  @override
  String get bannerIce => 'Bannière glaciale';

  @override
  String get bannerNeon => 'Bannière néon';
}
