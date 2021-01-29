import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

//TODO: Change your Api Key her ( only this api will work for this project https://bit.ly/AzulApiRegister )
const apiKey = 'd98b5dd18c0959d11c89a14b308a209913bdd75c7a4447453740002452';

//TODO: Change your Key OneSignal
const YOUR_ONESIGNAL_APP_ID = '0f20b5a5-9501-4588-ba12-05cadf1949af';

//TODO: Color App
const kColorPrimary = Color(0xFF251F29);
const kColorPrimaryDark = Color(0xFF392F46);
const kColorAccent = Color(0xFF392F46);
const kColorBlack1 = Color(0xFF262626);

//TODO: Your Infu
const kLinkWhatsap = 'https://www.instagram.com/moad_dev/';
const kLinkInstagram = 'https://www.instagram.com/moad_dev/';
const kLinkPrivacyPolicy = 'https://example.com';

//TODO: Link To Rate App
const kLinkRateApp =
    'https://play.google.com/store/apps/details?id=com.md.kooramd';

//TODO: Message Share App
const kShareApp = '{Change only this message} $kLinkRateApp';

//TODO: Your Facebook audience
const kIdBannerFacebook = '613662232606208_613672325938532';
const kIdInterstitialFacebook = '613662232606208_613672565938508';
const kIdNativeFacebook = '613662232606208_613662349272863';
const kIdNativeBannerFacebook = '613662232606208_613671965938568';

//TODO: About Page
const kDescripABout =
    'Displays an About dialog, which describes the application.';

///
///
///
///
///
///
///
///
///
///
///  Do Not change!!
///
///
///
///
///
///
///
///
///
///

const kHeightLogoTeam = 55.0;

///BlurShadow
const kShadow1 = BoxShadow(
  color: Color(0xFFE0E0E0),
  offset: Offset(1, 1),
  blurRadius: 10.0,
);

///BorderRaduis 5
const kBlureCont5 = BorderRadius.all(Radius.circular(5));

///Styles
const kHeightNumToolbar = 50.0;
const kStyleScore = TextStyle(
  color: kColorBlack1,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Tajawal',
);
const kStyleNameTeams = TextStyle(
  fontSize: 15.0,
  color: kColorBlack1,
  fontWeight: FontWeight.bold,
  fontFamily: 'Tajawal',
);
const kStyleChoose_1 = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Tajawal',
);
const kStyleChoose_2 = TextStyle(
  color: kColorBlack1,
  fontWeight: FontWeight.bold,
  fontFamily: 'Tajawal',
);
const kStyleScoreTime = TextStyle(
  fontFamily: 'Tajawal',
  fontWeight: FontWeight.w600,
);
const kStyleScoreVote = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  fontFamily: 'Tajawal',
);
const kStyleTextVote =
    TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold);
const kStyleNewsMoreNews = TextStyle(
  fontFamily: 'Tajawal',
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
);

var dateDays = DateFormat.d().format(DateTime.now());
var dateNumDays = DateFormat.EEEE().format(DateTime.now());
var dateYears = DateFormat.y().format(DateTime.now());
var dateMonth = DateFormat.M().format(DateTime.now());
var finDate = '$dateNumDays - $dateDays - $dateMonth - $dateYears';
var dateToGetMatches =
    '$dateYears-$dateMonth-$dateDays'; //this date can be changed

class KStyleTextFaild extends StatelessWidget {
  final Widget childCard;
  KStyleTextFaild({this.childCard});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50.0))),
      child: childCard,
    );
  }
}

void showToast(BuildContext context, {var message, Color color}) {
  Toast.show(
    "$message",
    context,
    duration: Toast.LENGTH_LONG,
    gravity: Toast.TOP,
    textColor: Colors.white,
    backgroundColor: color ?? Colors.red,
  );
}
