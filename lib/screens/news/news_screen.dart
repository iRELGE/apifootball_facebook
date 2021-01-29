import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kooramd/widgets/toolbares_widgets.dart';
import 'package:kooramd/widgets/widgets_news.dart';
import 'package:kooramd/widgets/widgets_facebook.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _firebase = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ToolbareNews(
              assetImage: 'news.svg',
              title: 'News Sport',
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firebase.collection('News').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LinearProgressIndicator();
                    }
                    final mAllNews = snapshot.data.documents;
                    List<CardNews> mListCardNews = [];

                    for (var news in mAllNews) {
                      mListCardNews.add(
                        CardNews(
                          titleNews: news.data['title'],
                          uidNews: news.documentID,
                          showAds: () async {
                            await WidgetesAdmob.showInterstitialFacebook();
                          },
                        ),
                      );
                    }

                    return ListView(
                      children: mListCardNews,
                    );
                  }),
            ),
            setBannerFacebook(),
          ],
        ),
      ),
    );
  }
}
