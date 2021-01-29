import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kooramd/constants.dart';
import 'package:kooramd/widgets/main_widgets.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;

class InfuScreen extends StatefulWidget {
  final nameHome;
  final nameAway;

  InfuScreen({
    @required this.nameHome,
    @required this.nameAway,
  });

  @override
  _InfuScreenState createState() => _InfuScreenState();
}

class _InfuScreenState extends State<InfuScreen> {
  var message;

  @override
  void initState() {
    super.initState();

    setState(() {
      message = '${widget.nameAway} vs ${widget.nameAway} \n $kLinkRateApp';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Card(
            elevation: 5.0,
            shadowColor: Colors.black54.withOpacity(0.3),
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.share),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Share the match',
                        style: kStyleChoose_2,
                      ),
                      SizedBox(
                        width: 50.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CardShareMatch(
                          icon: FontAwesomeIcons.facebook,
                          onPress: () async {
                            await FlutterShareMe().shareToFacebook(
                                msg: '${widget.nameAway} vs ${widget.nameHome}',
                                url: kLinkRateApp);
                          },
                        ),
                        CardShareMatch(
                          icon: FontAwesomeIcons.whatsapp,
                          onPress: () async {
                            await FlutterShareMe()
                                .shareToWhatsApp(msg: '$message');
                          },
                        ),
                        CardShareMatch(
                          icon: FontAwesomeIcons.twitter,
                          onPress: () async {
                            await FlutterShareMe().shareToTwitter(
                                msg: '${widget.nameAway} vs ${widget.nameHome}',
                                url: kLinkRateApp);
                          },
                        ),
                        CardShareMatch(
                          icon: FontAwesomeIcons.shareAlt,
                          onPress: () async {
                            await FlutterShareMe()
                                .shareToSystem(msg: '$message');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          WidgetesAdmob.showNativeFacebook()
        ],
      ),
    );
  }
}
