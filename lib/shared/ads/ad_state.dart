import 'package:ch_db_admin/shared/utils/custom_print.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initializationStatus;

  AdState({
    required this.initializationStatus,
  });

  // Test and actual ad unit IDs
  static const String testAdUnitId = 'ca-app-pub-3940256099942544/9214589741';
  static const String actualAdUnitId = 'ca-app-pub-7606494628821479~2182971866';

  String get bannerAdUnitId {
    miPrint('Using test ad unit ID: $testAdUnitId');

    // Return the appropriate ad unit ID based on debug mode
    return kDebugMode ? testAdUnitId : actualAdUnitId;
  }

  BannerAdListener get adListener => BannerAdListener(
        onAdLoaded: (ad) {
          miPrint('$ad loaded.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          miPrint('BannerAd failed to load: $err');

          // Dispose the ad here to free resources.
          ad.dispose();
        },
        onAdOpened: (Ad ad) {
          miPrint('$ad opened');
        },
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          miPrint('$ad closed');
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {
          miPrint('$ad impression');
        },
      );
}
