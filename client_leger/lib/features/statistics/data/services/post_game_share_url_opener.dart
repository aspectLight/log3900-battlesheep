import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class PostGameShareUrlOpener {
  static Uri _tweetIntentUri(String host, String text) {
    final encoded = Uri.encodeComponent(text);
    return Uri.parse('https://$host/intent/tweet?text=$encoded');
  }

  /// Opens X sign-in; after authentication, X redirects to the tweet intent (draft).
  static Uri _loginThenTweetUri(String host, String text) {
    final intentUrl =
        'https://$host/intent/tweet?text=${Uri.encodeComponent(text)}';
    final encodedIntent = Uri.encodeComponent(intentUrl);
    return Uri.parse(
      'https://$host/i/flow/login?redirect_after_login=$encodedIntent',
    );
  }

  Future<bool> _launchUri(Uri uri) async {
    try {
      if (kIsWeb) {
        return await launchUrl(uri, webOnlyWindowName: '_blank');
      }

      // On Android, `launchUrl` may throw (ex: no activity found). In that case,
      // we want to fail gracefully so callers can try fallback URLs.
      final supported = await canLaunchUrl(uri);
      if (!supported) {
        return false;
      }

      final external = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (external) {
        return true;
      }

      return await launchUrl(uri);
    } on Exception catch (e) {
      debugPrint('Failed to launch url: $uri ($e)');
      return false;
    }
  }

  Future<bool> _launchUriInBrowserView(Uri uri) async {
    if (kIsWeb) {
      return launchUrl(uri, webOnlyWindowName: '_blank');
    }
    try {
      final supported = await canLaunchUrl(uri);
      if (!supported) {
        return false;
      }
      // Force a browser UI so login prompts keep the query parameters.
      final opened = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      if (opened) {
        return true;
      }
    } on Exception catch (e) {
      debugPrint('Failed to launch browser view url: $uri ($e)');
    }
    // Fallback to the default behavior (may open app links).
    return _launchUri(uri);
  }

  Future<bool> openXShareText(String text) async {
    final candidates = <Uri>[
      _loginThenTweetUri('twitter.com', text),
      _loginThenTweetUri('x.com', text),
      _tweetIntentUri('twitter.com', text),
      _tweetIntentUri('x.com', text),
    ];
    for (final uri in candidates) {
      if (await _launchUri(uri)) {
        return true;
      }
    }
    return false;
  }

  static const int _blueskyComposerTextMaxLength = 300;

  static String _truncateForBlueskyComposer(String text) {
    if (text.length <= _blueskyComposerTextMaxLength) {
      return text;
    }
    return '${text.substring(0, _blueskyComposerTextMaxLength - 1)}…';
  }

  /// [Bluesky intent](https://docs.bsky.app/docs/advanced-guides/intent-links) expects
  /// `text` URL-encoded with `%20` for spaces. Using [Uri.queryParameters] encodes
  /// spaces as `+`, which some clients mishandle, so we build the query with
  /// [Uri.encodeComponent] only.
  static Uri _blueskyComposeUriHttps(String clippedText) {
    final encoded = Uri.encodeComponent(clippedText);
    return Uri.parse('https://bsky.app/intent/compose?text=$encoded');
  }

  static Uri _blueskyComposeUriNative(String clippedText) {
    final encoded = Uri.encodeComponent(clippedText);
    return Uri.parse('bluesky://intent/compose?text=$encoded');
  }

  Future<bool> openBlueskyShareText(String text) async {
    final clipped = _truncateForBlueskyComposer(text);
    final httpsUri = _blueskyComposeUriHttps(clipped);

    if (!kIsWeb) {
      // Prefer the native app intent so the app can handle auth (login) and
      // then continue into the compose flow with the pre-filled text.
      if (await _launchUri(_blueskyComposeUriNative(clipped))) {
        return true;
      }

      // Fallback: open the web intent in a browser view.
      if (await _launchUriInBrowserView(httpsUri)) {
        return true;
      }
    }

    return _launchUri(httpsUri);
  }
}
