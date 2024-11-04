import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class _AnchoredBannerIds {
  final String ios;
  final String android;

  _AnchoredBannerIds({required this.ios, required this.android});

  factory _AnchoredBannerIds.prod() {
    return _AnchoredBannerIds(
      ios: 'ca-app-pub-2770822892374175/5775785524',
      android: 'ca-app-pub-2770822892374175/8900172159',
    );
  }

  factory _AnchoredBannerIds.test() {
    return _AnchoredBannerIds(
      ios: 'ca-app-pub-3940256099942544/2435281174',
      android: 'ca-app-pub-3940256099942544/9214589741',
    );
  }
}

class AnchoredBanner extends StatefulWidget {
  const AnchoredBanner({super.key});

  @override
  State<AnchoredBanner> createState() => _AnchoredBannerState();
}

class _AnchoredBannerState extends State<AnchoredBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  late final String _adUnitId;

  @override
  void initState() {
    super.initState();
    _adUnitId = getAdUnitId();
    _loadAd();
  }

  /// Loads a banner ad.
  void _loadAd() async {
    AdSize size;
    try {
      size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
              MediaQuery.of(context).size.width.truncate()) ??
          AdSize.banner;
    } catch (e) {
      size = AdSize.banner;
    }

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        );
      },
    );
  }

  String getAdUnitId() {
    if (Platform.isAndroid) {
      return const bool.fromEnvironment('PRODUCTION')
          ? _AnchoredBannerIds.prod().android
          : _AnchoredBannerIds.test().android;
    } else {
      return const bool.fromEnvironment('PRODUCTION')
          ? _AnchoredBannerIds.prod().ios
          : _AnchoredBannerIds.test().ios;
    }
  }
}
