import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyAdController extends GetxController {
  // Replace these with actual Ad Unit IDs from AdMob
  final String bannerAdUnit = 'ca-app-pub-3940256099942544/6300978111';
  final String interstitialAdUnit = 'ca-app-pub-3940256099942544/1033173712';
  final String rewardedAdUnit = 'ca-app-pub-3940256099942544/5224354917';
  final String rewardedInterstitialAdUnit =
      'ca-app-pub-2818463232907910/5522308465';
  final String nativeAdUnit = 'ca-app-pub-2818463232907910/5522308465';
  final String appOpenAdUnit = 'ca-app-pub-2a818463232907910/5522308465';

  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;
  RewardedInterstitialAd? rewardedInterstitialAd;
  NativeAd? nativeAd;
  AppOpenAd? appOpenAd;
  bool hasShownInitialAd = false;

  bool isAppOpenAdLoaded = false;

  @override
  void onInit() {
    super.onInit();
    MobileAds.instance.initialize();
    loadAllAds();
  }

  /// Load all ads when initializing
  void loadAllAds() {
    loadBannerAd();
    loadInterstitialAd();
    loadRewardedAd();
    loadRewardedInterstitialAd();
    loadNativeAd();
    loadAppOpenAd();
  }

  // 🔹 Load Banner Ad
  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: bannerAdUnit,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => debugPrint("✅ Banner Ad Loaded"),
        onAdFailedToLoad: (ad, error) {
          debugPrint("❌ Banner Ad Failed: $error");
          ad.dispose();
        },
      ),
    )..load();
  }

  // 🔹 Load Interstitial Ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnit,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => interstitialAd = ad,
        onAdFailedToLoad: (error) =>
            debugPrint("❌ Interstitial Ad Failed: $error"),
      ),
    );
  }

  void showInitialInterstitialAdIfAvailable() {
    if (!hasShownInitialAd && interstitialAd != null) {
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd(); // Reload the ad after dismissal
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd(); // Reload the ad on failure
        },
      );
      interstitialAd!.show();
      interstitialAd = null;
      hasShownInitialAd = true;
    }
  }

  // 🔹 Show Interstitial Ad
  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
      interstitialAd = null;
      loadInterstitialAd(); // Reload for next use
    } else {
      debugPrint("⚠️ Interstitial Ad Not Loaded");
    }
  }

  // 🔹 Load Rewarded Ad
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnit,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => rewardedAd = ad,
        onAdFailedToLoad: (error) => debugPrint("❌ Rewarded Ad Failed: $error"),
      ),
    );
  }

  // 🔹 Show Rewarded Ad
  void showRewardedAd() {
    if (rewardedAd != null) {
      rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint("🎉 User earned reward: ${reward.amount}");
        },
      );
      rewardedAd = null;
      loadRewardedAd(); // Reload for next use
    } else {
      debugPrint("⚠️ Rewarded Ad Not Loaded");
    }
  }

  // 🔹 Load Rewarded Interstitial Ad
  void loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: rewardedInterstitialAdUnit,
      request: AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) => rewardedInterstitialAd = ad,
        onAdFailedToLoad: (error) =>
            debugPrint("❌ Rewarded Interstitial Ad Failed: $error"),
      ),
    );
  }

  // 🔹 Show Rewarded Interstitial Ad
  void showRewardedInterstitialAd() {
    if (rewardedInterstitialAd != null) {
      rewardedInterstitialAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint("🎉 User earned reward: ${reward.amount}");
        },
      );
      rewardedInterstitialAd = null;
      loadRewardedInterstitialAd();
    } else {
      debugPrint("⚠️ Rewarded Interstitial Ad Not Loaded");
    }
  }

  // 🔹 Load Native Ad
  void loadNativeAd() {
    nativeAd = NativeAd(
      adUnitId: nativeAdUnit,
      factoryId: 'listTile', // Ensure this is registered in Android/iOS
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) => debugPrint("✅ Native Ad Loaded"),
        onAdFailedToLoad: (ad, error) {
          debugPrint("❌ Native Ad Failed: $error");
          ad.dispose();
        },
      ),
    )..load();
  }

  // 🔹 Load App Open Ad
  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnit,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          isAppOpenAdLoaded = true;
        },
        onAdFailedToLoad: (error) => debugPrint("❌ App Open Ad Failed: $error"),
      ),
    );
  }

  // 🔹 Show App Open Ad
  void showAppOpenAd() {
    if (appOpenAd != null) {
      appOpenAd!.show();
      appOpenAd = null;
      isAppOpenAdLoaded = false;
      loadAppOpenAd();
    } else {
      debugPrint("⚠️ App Open Ad Not Loaded");
    }
  }

  /// Dispose ads properly to free memory
  @override
  void onClose() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
    rewardedAd?.dispose();
    rewardedInterstitialAd?.dispose();
    nativeAd?.dispose();
    appOpenAd?.dispose();
    super.onClose();
  }
}
