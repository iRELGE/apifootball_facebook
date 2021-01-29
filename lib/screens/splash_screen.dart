import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kooramd/constants.dart';
import 'package:kooramd/models/get_started.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final _firestore = Firestore.instance;

  Future<dynamic> checkConnection() async {
    try {
      final mResulte = await getConnection();
      if (mResulte == false) {
        print('Device is: Offline');
        await _firestore
            .collection('Lueges')
            .getDocuments(source: Source.cache);
        await _firestore.collection('News').getDocuments(source: Source.cache);
        goToWelcomeScreen(3);
      } else {
        print('Device is: Online');
        await _firestore
            .collection('Lueges')
            .getDocuments(source: Source.serverAndCache);
        await _firestore
            .collection('News')
            .getDocuments(source: Source.serverAndCache);
        goToWelcomeScreen(5);
      }
    } catch (e) {
      print('Error Conncetion $e');
    }
  }

  void goToWelcomeScreen(sleep) async {
    await Future.delayed(Duration(milliseconds: sleep));
    Navigator.pushReplacementNamed(context, '/welcome_screen');
    // Navigator.pushReplacement(context, ScaleRoute(page: WelcomeScreen()));
  }

  @override
  void initState() {
    super.initState();

    startAds();
    // checkConnection();
    goToWelcomeScreen(3500);
   // goToWelcomeScreen(5890);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: LoadingSplash(),
//      Container(
//        width: mSize.width,
//        height: mSize.height,
//        child: CachedNetworkImage(
//          width: mSize.width,
//          height: mSize.height,
//          imageUrl:
//              "https://firebasestorage.googleapis.com/v0/b/koora-live-6c386.appspot.com/o/splash_animated.gif?alt=media&token=d33b35a0-f743-41d1-9c0e-2f4e77309366",
//          fit: BoxFit.cover,
//          placeholder: (context, url) => Center(child: LoadingSplash()),
//          errorWidget: (context, url, error) => Icon(Icons.error),
//        ),
//      ),
    );
  }
}

class LoadingSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  child: SvgPicture.asset('images/icon_splash.svg'),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Column(
            children: <Widget>[
              SpinKitDoubleBounce(
                color: kColorPrimary,
                size: 50.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Text(
                'Please wait amoment...',
                style: TextStyle(fontFamily: 'Tajawal'),
              )),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[],
          )
        ],
      ),
    );
  }
}
