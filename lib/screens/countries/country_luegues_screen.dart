import 'package:flutter/material.dart';
import 'package:kooramd/constants.dart';
import 'package:kooramd/screens/countries/picked_luge_screen.dart';
import 'package:kooramd/models/api/data_countries.dart' as countries;
import 'package:kooramd/widgets/toolbares_widgets.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;

class CountryLugeScreen extends StatefulWidget {
  final idCountry;
  final nameCountry;
  final imageCountry;

  CountryLugeScreen(
      {@required this.idCountry,
      @required this.nameCountry,
      @required this.imageCountry});

  @override
  _CountryLugeScreenState createState() => _CountryLugeScreenState();
}

class _CountryLugeScreenState extends State<CountryLugeScreen> {
  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ToolbarCountries(
              luegesName: widget.nameCountry,
              logoLueges: widget.imageCountry,
              logoAssest: 'null',
            ),
            FutureBuilder(
                future:
                    countries.getDataCompetition(idCountry: widget.idCountry),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LinearProgressIndicator();
                  }

                  List<CardLuges> mListCardLuges = [];
                  for (var lueges in snapshot.data) {
                    //  print(lueges['league_name']);
                    mListCardLuges.add(
                      CardLuges(
                        mSize: mSize,
                        title: lueges['league_name'],
                        image: lueges['league_logo'],
                        idCountry: lueges['league_id'],
                      ),
                    );
                  }

                  return Flexible(
                    child: ListView(
                      children: mListCardLuges,
                    ),
                  );
                }),
            WidgetesAdmob.setBannerFacebook(),
          ],
        ),
      ),
    );
  }
}

class CardLuges extends StatelessWidget {
  final mSize;
  final image;
  final title;
  final idCountry;

  CardLuges(
      {@required this.mSize,
      @required this.image,
      @required this.title,
      @required this.idCountry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await WidgetesAdmob.showInterstitialFacebook();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PickedLugeScreen(
                      idLuge: idCountry,
                      logoLuge: image,
                      nameLuge: title,
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 2.0),
        width: mSize.width,
        color: Colors.white,
        child: Row(
          children: [
            image.toString() != ""
                ? Image(
                    image: NetworkImage(image),
                    height: 60.0,
                    errorBuilder: (context, d, f) {
                      return NoImage();
                    },
                  )
                : NoImage(),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
                child: Text(
              '$title',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: kColorPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class NoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: kColorPrimaryDark,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Center(
        child: Text(
          'No image',
          style: TextStyle(
              fontFamily: 'Tajawal', color: Colors.white, fontSize: 9.0),
        ),
      ),
    );
  }
}
