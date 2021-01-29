
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kooramd/constants.dart';
import 'package:kooramd/screens/countries/country_luegues_screen.dart';
import 'package:kooramd/models/api/data_countries.dart' as countries;
import 'package:kooramd/widgets/toolbares_widgets.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;

class CountriesScreen extends StatefulWidget {
  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ToolbarCountries(
              luegesName: 'All countries',
              logoLueges: '',
              logoAssest: 'soccer.svg',
            ),
            FutureBuilder(
                future: countries.getDataCounties(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LinearProgressIndicator();
                  }

                  List<CardCountries> mListCardCountries = [];
                  for (var country in snapshot.data) {
                    mListCardCountries.add(
                      CardCountries(
                        mSize: mSize,
                        title: country['country_name'],
                        image: country['country_logo'],
                        idCountry: country['country_id'],
                      ),
                    );
                  }

                  return Flexible(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: mListCardCountries.length,
                      itemBuilder: (context, index) {
                        return mListCardCountries[index];
                      },
                      separatorBuilder: (context, index) {
                        if (index % 8 == 3) {
                          return Container(
                            color: Colors.white,
                            child: WidgetesAdmob.showNativeFacebookBanner(),
                          );
                        }
                        return Container();
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class CardCountries extends StatelessWidget {
  final mSize;
  final image;
  final title;
  final idCountry;

  CardCountries(
      {@required this.mSize,
      @required this.image,
      @required this.title,
      @required this.idCountry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CountryLugeScreen(
                      idCountry: idCountry,
                      imageCountry: image,
                      nameCountry: title,
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 2.0),
        width: mSize.width,
        color: Colors.white,
        child: Row(
          children: [
            Container(
                width: 65.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: kColorPrimaryDark,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: image.toString() == ""
                    ? NoImage()
                    : Hero(
                        tag: '$title',
                        child: Image(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                          errorBuilder: (context, c, d) {
                            return NoImage();
                          },
                        ))),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
                child: Text(
              '$title',
              style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: kColorPrimaryDark,
                  fontWeight: FontWeight.bold),
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
    return Center(
      child: Text(
        'No image',
        style: TextStyle(
            fontFamily: 'Tajawal', color: Colors.white, fontSize: 9.0),
      ),
    );
  }
}
