import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kooramd/constants.dart';
import 'package:kooramd/screens/news/content_news.dart';
import 'package:kooramd/screens/news/more_news.dart';

class CardNews extends StatelessWidget {
  final titleNews;
  final uidNews;
  final Function showAds;
  CardNews(
      {@required this.titleNews,
      @required this.uidNews,
      @required this.showAds});

  final _firebase = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '$titleNews',
                  style: kStyleNewsMoreNews,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MoreNewsScreen(
                                uidNews: uidNews, titleNews: titleNews)));
                  },
                  child: Text(
                    'more',
                    style: kStyleNewsMoreNews,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _firebase
                  .collection('News')
                  .document(uidNews)
                  .collection('News')
                  .orderBy('date', descending: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final mNewsList = snapshot.data.documents;
                List<CardPostNews> mListCardPostNews = [];

                for (var news in mNewsList) {
                  mListCardPostNews.add(
                    CardPostNews(
                      title: news.data['title'],
                      titleCatyNews: titleNews,
                      descrip: news.data['descrip'],
                      image: news.data['image'],
                      date: news.data['date'],
                      uidPost: news.documentID,
                      uidNews: uidNews,
                      showAds: showAds,
                    ),
                  );
                }

                return CarouselSlider(
                  items: mListCardPostNews,
                  options: CarouselOptions(
                    height: 180.0,
                    scrollDirection: Axis.horizontal,
                    enlargeCenterPage: true,
                    // aspectRatio: 2.0,
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class CardPostNews extends StatelessWidget {
  final title, titleCatyNews;
  final descrip;
  final image;
  final uidPost, uidNews;
  final date;
  final Function showAds;

  CardPostNews({
    @required this.title,
    @required this.titleCatyNews,
    @required this.descrip,
    @required this.image,
    @required this.uidPost,
    @required this.uidNews,
    @required this.date,
    @required this.showAds,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContentNewsScreen(
                      uidPost: uidPost,
                      title: title,
                      descrip: descrip,
                      image: image,
                      date: date,
                      uidNews: uidNews,
                      titleCatyNews: titleCatyNews,
                    )));
        showAds();
      },
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Hero(
              tag: Text('imagePost'),
              child: Container(
                //height: 150.0,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: kColorPrimaryDark,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  image: DecorationImage(
                    image: NetworkImage(image),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 80.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                          color: kColorPrimaryDark.withOpacity(0.8),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Center(
                        child: Text(
                          '$date',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        '$title',
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            fontFamily: 'Tajawal'),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        '$descrip',
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.0,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardPostNewsList extends StatelessWidget {
  final title, titleNews;
  final descrip;
  final image;
  final uidPost;
  final uidNews;
  final date;
  final Function showAds;

  CardPostNewsList({
    @required this.title,
    @required this.titleNews,
    @required this.descrip,
    @required this.image,
    @required this.uidPost,
    @required this.uidNews,
    @required this.date,
    @required this.showAds,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContentNewsScreen(
                        uidPost: uidPost,
                        uidNews: uidNews,
                        title: title,
                        descrip: descrip,
                        image: image,
                        date: date,
                        titleCatyNews: titleNews,
                      )));
          showAds();
        },
        child: Material(
          elevation: 2.0,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Hero(
                tag: Text('imagePost'),
                child: Container(
                  height: 165.0,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: kColorPrimaryDark,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                height: 165.0,
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  gradient: LinearGradient(
                    colors: [Colors.transparent, kColorPrimaryDark],
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 100.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                            color: kColorPrimaryDark.withOpacity(0.8),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        child: Center(
                          child: Text(
                            '$date',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          '$title',
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              fontFamily: 'Tajawal'),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          '$descrip',
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10.0,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
