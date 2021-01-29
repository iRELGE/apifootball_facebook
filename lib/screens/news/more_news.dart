import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kooramd/widgets/widgets_news.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;

class MoreNewsScreen extends StatefulWidget {
  final uidNews;
  final titleNews;

  MoreNewsScreen({@required this.uidNews, @required this.titleNews});

  @override
  _MoreNewsScreenState createState() => _MoreNewsScreenState();
}

class _MoreNewsScreenState extends State<MoreNewsScreen> {
  final _firebase = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${widget.titleNews}',
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            style:
                TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 15.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _firebase
                  .collection('News')
                  .document(widget.uidNews)
                  .collection('News')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LinearProgressIndicator();
                }
                final mDataNews = snapshot.data.documents;
                List<CardPostNewsList> mListCardNews = [];

                for (var news in mDataNews) {
                  mListCardNews.add(
                    CardPostNewsList(
                      title: news.data['title'],
                      descrip: news.data['descrip'],
                      image: news.data['image'],
                      date: news.data['date'],
                      uidPost: news.documentID,
                      uidNews: widget.uidNews,
                      titleNews: widget.titleNews,
                      showAds: () async {
                        await WidgetesAdmob.showInterstitialFacebook();
                      },
                    ),
                  );
                }

                return Flexible(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: mListCardNews,
                  ),
                );
              }),
          WidgetesAdmob.setBannerFacebook(),
        ],
      ),
    );
  }
}
