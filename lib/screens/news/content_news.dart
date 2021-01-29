

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kooramd/constants.dart';
import 'package:kooramd/widgets/main_widgets.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;
import 'package:kooramd/widgets/widgets_news.dart';

class ContentNewsScreen extends StatefulWidget {
  final uidPost, uidNews;
  final title;
  final titleCatyNews;
  final image;
  final descrip;
  final date;
  ContentNewsScreen({
    @required this.uidPost,
    @required this.uidNews,
    @required this.title,
    @required this.titleCatyNews,
    @required this.image,
    @required this.descrip,
    @required this.date,
  });

  @override
  _ContentNewsScreenState createState() => _ContentNewsScreenState();
}

class _ContentNewsScreenState extends State<ContentNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          RawToolbar(widget: widget),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                CardShare(
                  title: widget.title,
                  descrip: widget.descrip,
                ),
                //Ads Native
                WidgetesAdmob.showNativeFacebook(),
                Card(
                  elevation: 5.0,
                  shadowColor: Colors.black54.withOpacity(0.3),
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 100.0,
                            height: 25.0,
                            decoration: BoxDecoration(
                                color: kColorPrimaryDark.withOpacity(0.8),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            child: Center(
                              child: Text(
                                '${widget.date}',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          widget.descrip,
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),

                CardNews(
                  showAds: () async {
                    await WidgetesAdmob.showInterstitialFacebook();
                  },
                  titleNews: widget.titleCatyNews,
                  uidNews: widget.uidNews,
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RawToolbar extends StatelessWidget {
  RawToolbar({
    @required this.widget,
  });
  final ContentNewsScreen widget;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 15.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 16),
        title: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            widget.title,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            style: TextStyle(fontFamily: 'Tajawal', fontSize: 18.0),
          ),
        ),
        background: Stack(
          children: <Widget>[
            Hero(
              tag: Text('imagePost'),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(7.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                gradient: LinearGradient(
                  colors: [Colors.transparent, kColorPrimaryDark],
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardShare extends StatelessWidget {
  final title;
  final descrip;
  CardShare({@required this.title, @required this.descrip});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shadowColor: Colors.black54.withOpacity(0.3),
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Icon(Icons.share),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Share the news',
                  style: kStyleChoose_2.copyWith(fontSize: 15.0),
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
                          msg: '$title \n\n$descrip\n', url: '$kLinkRateApp');
                    },
                  ),
                  CardShareMatch(
                    icon: FontAwesomeIcons.whatsapp,
                    onPress: () async {
                      await FlutterShareMe().shareToWhatsApp(
                          msg: "$title \n\n$descrip\n$kLinkRateApp");
                    },
                  ),
                  CardShareMatch(
                    icon: FontAwesomeIcons.twitter,
                    onPress: () async {
                      await FlutterShareMe().shareToTwitter(
                          msg: '$title \n\n$descrip\n', url: '$kLinkRateApp');
                    },
                  ),
                  CardShareMatch(
                    icon: FontAwesomeIcons.shareAlt,
                    onPress: () async {
                      await FlutterShareMe().shareToSystem(
                          msg: '$title \n\n$descrip\n$kLinkRateApp');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
