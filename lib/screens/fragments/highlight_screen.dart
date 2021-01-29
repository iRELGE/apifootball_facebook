import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kooramd/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HighLightsScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final uid_luege;
  final dateMatche;
  // ignore: non_constant_identifier_names
  final codument_id_match;

  // ignore: non_constant_identifier_names
  HighLightsScreen({this.uid_luege, this.dateMatche, this.codument_id_match});

  @override
  _HighLightsScreenState createState() => _HighLightsScreenState();
}

class _HighLightsScreenState extends State<HighLightsScreen> {
  final firebase = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: firebase
              .collection('Lueges')
              .document('${widget.uid_luege}')
              .collection('Date')
              .document('${widget.dateMatche}')
              .collection('Matches')
              .document('${widget.codument_id_match}')
              .collection('HightLights')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final mDataVideos = snapshot.data.documents;
            List<ListItemVideo> mlistItem = [];

            for (var video in mDataVideos) {
              print(video);
              var link = video['link'];
              var image = video['image'];

              mlistItem.add(
                ListItemVideo(
                  image: image,
                  link: link,
                ),
              );
            }

            return Center(
              child: CarouselSlider(
                items: mlistItem,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  scrollDirection: Axis.vertical,
                  enlargeCenterPage: true,
                ),
              ),
            );
          }),
    );
  }
}

class ListItemVideo extends StatelessWidget {
  final image;
  final link;

  ListItemVideo({@required this.image, @required this.link});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launch(link);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: 250.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: kColorPrimaryDark,
          image: DecorationImage(
            image: NetworkImage('$image'),
            fit: BoxFit.cover,
            colorFilter: link != ''
                ? ColorFilter.mode(
                    kColorPrimaryDark.withOpacity(0.4), BlendMode.dstATop)
                : null,
          ),
        ),
        child: Center(
          child: link != ''
              ? Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 80.0,
                )
              : Container(),
        ),
      ),
    );
  }
}
