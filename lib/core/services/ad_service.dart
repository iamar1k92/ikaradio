import 'dart:async';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:base/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdService {
  init() {
    Admob.initialize();
  }

  Widget buildBannerAd() {
    return Container(
      width: double.infinity,
      child: AdmobBanner(
        adUnitId: Platform.isAndroid ? sl<DotEnv>().env['ANDROID_ADMOB_BANNER_UNIT_ID'] : sl<DotEnv>().env['IOS_ADMOB_BANNER_UNIT_ID'],
        adSize: AdmobBannerSize.BANNER,
      ),
    );
  }

  buildInterstitialAd() async {
    AdmobInterstitial interstitialAd = AdmobInterstitial(
      adUnitId: Platform.isAndroid ? sl<DotEnv>().env['ANDROID_ADMOB_INTERSTITIAL_UNIT_ID'] : sl<DotEnv>().env['IOS_ADMOB_INTERSTITIAL_UNIT_ID'],
    );

    interstitialAd.load();

    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (await interstitialAd.isLoaded) {
        interstitialAd.show();
        timer.cancel();
      }
    });

    return true;
  }
}
