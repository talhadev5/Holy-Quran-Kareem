import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyAdController extends GetxController {
  // Replace these with actual Ad Unit IDs from AdMob
  final String bannerAdUnit = 'ca-app-pub-2818463232907910/5618149997';
  final String interstitialAdUnit = 'ca-app-pub-2818463232907910/5945088091';
  final String rewardedAdUnit = 'ca-app-pub-2818463232907910/1323316801';
  final String rewardedInterstitialAdUnit =
      'ca-app-pub-2818463232907910/2594501026';
  final String nativeAdUnit = 'ca-app-pub-2818463232907910/1323316801';
  final String appOpenAdUnit = 'ca-app-pub-2818463232907910/2007311698';

  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;
  RewardedInterstitialAd? rewardedInterstitialAd;
  NativeAd? nativeAd;
  AppOpenAd? appOpenAd;
  bool hasShownInitialAd = false;

  bool isAppOpenAdLoaded = false; // Track if App Open Ad is loaded

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
        onAdLoaded: (_) => debugPrint(" Banner Ad Loaded"),
        onAdFailedToLoad: (ad, error) {
          debugPrint(" Banner Ad Failed: $error");
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
            debugPrint(" Interstitial Ad Failed: $error"),
      ),
    );
  }

  // 🔹 Show Interstitial Ad
  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
      interstitialAd = null;
      loadInterstitialAd(); // Reload for next use
    } else {
      debugPrint(" Interstitial Ad Not Loaded");
    }
  }

  // 🔹 Load Rewarded Ad
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnit,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => rewardedAd = ad,
        onAdFailedToLoad: (error) => debugPrint(" Rewarded Ad Failed: $error"),
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
      debugPrint("Rewarded Ad Not Loaded");
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
            debugPrint(" Rewarded Interstitial Ad Failed: $error"),
      ),
    );
  }

  // 🔹 Show Rewarded Interstitial Ad
  void showRewardedInterstitialAd() {
    if (rewardedInterstitialAd != null) {
      rewardedInterstitialAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint("User earned reward: ${reward.amount}");
        },
      );
      rewardedInterstitialAd = null;
      loadRewardedInterstitialAd();
    } else {
      debugPrint(" Rewarded Interstitial Ad Not Loaded");
    }
  }

  RxBool isAdLoaded = false.obs;

  // 🔹 Load Native Ad
  void loadNativeAd() {
    nativeAd = NativeAd(
        adUnitId: nativeAdUnit,
        factoryId: 'video',
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isAdLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isAdLoaded.value = false;
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.small));
    nativeAd!.load();
  }

  // 🔹 Load App Open Ad

  loadAppOpenAd({VoidCallback? onAdLoaded}) {
    AppOpenAd.load(
      adUnitId: appOpenAdUnit,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          isAppOpenAdLoaded = true;
          debugPrint(" App Open Ad Loaded");

          // Show ad if callback is provided
          if (onAdLoaded != null) {
            onAdLoaded();
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint("Failed to load App Open Ad: $error");
          isAppOpenAdLoaded = false;
        },
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
      debugPrint(" App Open Ad Not Loaded");
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
