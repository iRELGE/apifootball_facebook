import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:kooramd/constants.dart';

Widget setBannerFacebook() {
  return Container(
    alignment: Alignment(0.5, 1),
    child: FacebookBannerAd(
      placementId: kIdBannerFacebook,
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        switch (result) {
          case BannerAdResult.ERROR:
            print("Error: $value");
            break;
          case BannerAdResult.LOADED:
            print("Loaded: $value");
            break;
          case BannerAdResult.CLICKED:
            print("Clicked: $value");
            break;
          case BannerAdResult.LOGGING_IMPRESSION:
            print("Logging Impression: $value");
            break;
        }
      },
    ),
  );
}

FacebookBannerAd setLARGEBannerFacebook() {
  return FacebookBannerAd(
    placementId: kIdBannerFacebook,
    bannerSize: BannerSize.LARGE,
    listener: (result, value) {
      switch (result) {
        case BannerAdResult.ERROR:
          print("Error: $value");
          break;
        case BannerAdResult.LOADED:
          print("Loaded: $value");
          break;
        case BannerAdResult.CLICKED:
          print("Clicked: $value");
          break;
        case BannerAdResult.LOGGING_IMPRESSION:
          print("Logging Impression: $value");
          break;
      }
    },
  );
}

Future<void> showInterstitialFacebook() async {
  await FacebookInterstitialAd.loadInterstitialAd(
    placementId: kIdInterstitialFacebook,
    listener: (result, value) {
      if (result == InterstitialAdResult.LOADED) {
        FacebookInterstitialAd.showInterstitialAd();
      }
    },
  );
}

Widget showNativeFacebook() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5.0,
            offset: Offset(1, 1))
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: FacebookNativeAd(
        placementId: kIdNativeFacebook,
        adType: NativeAdType.NATIVE_AD,
        width: double.infinity,
        height: 330,
        backgroundColor: Colors.white,
        titleColor: kColorBlack1,
        descriptionColor: kColorBlack1,
        buttonColor: Colors.white,
        buttonTitleColor: kColorBlack1,
        buttonBorderColor: kColorBlack1,
        keepAlive:
            true, //set true if you do not want adview to refresh on widget rebuild
        keepExpandedWhileLoading:
            false, // set false if you want to collapse the native ad view when the ad is loading
        expandAnimationDuraion:
            300, //in milliseconds. Expands the adview with animation when ad is loaded
        listener: (result, value) {
          print("Native Ad: $result --> $value");
        },
      ),
    ),
  );
}

Widget showNativeFacebookBanner() {
  return SizedBox(
    height: 120.0,
    child: FacebookNativeAd(
      placementId: kIdNativeBannerFacebook,
      adType: NativeAdType.NATIVE_BANNER_AD,
      bannerAdSize: NativeBannerAdSize.HEIGHT_120,
      width: double.infinity,
      backgroundColor: Colors.white,
      titleColor: kColorBlack1,
      descriptionColor: kColorBlack1,
      buttonColor: kColorBlack1,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
    ),
  );
}
