import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kooramd/screens/countries/countries_screen.dart';
import 'package:kooramd/screens/more/help_screen.dart';
import 'package:kooramd/screens/more_screen.dart';
import 'package:kooramd/screens/news/news_screen.dart';
import 'package:kooramd/screens/splash_screen.dart';
import 'constants.dart';
import 'package:kooramd/screens/welcome_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(MyApp());
  FacebookAudienceNetwork.init();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void getNotificationMessages() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //  _navigateToItemDetail(message);
      },
    );

    OneSignal.shared.init(YOUR_ONESIGNAL_APP_ID, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  @override
  void initState() {
    getNotificationMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: kColorPrimary));
    return MaterialApp(
      title: 'Footbale API',
      theme: ThemeData.light().copyWith(
        primaryColor: kColorPrimary,
        accentColor: kColorPrimaryDark,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/welcome_screen': (context) => WelcomeScreen(),
        '/news_screen': (context) => NewsScreen(),
        '/more_screen': (context) => MoreScreen(),
        '/countries_screen': (context) => CountriesScreen(),
        '/help_screen': (context) => HelpScreen(),
      },
    );
  }
}
