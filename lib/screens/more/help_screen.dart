import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kooramd/constants.dart';
import 'package:kooramd/widgets/toolbares_widgets.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _auth = FirebaseAuth.instance;
  final _firebase = Firestore.instance;
  var selected = 'FeedBack';
  var date = DateFormat('y-M-d').format(DateTime.now());

  var descripUser = '';
  final _nameControler = TextEditingController();
  final _emailControler = TextEditingController();
  final _descripControler = TextEditingController();

  Future<void> uploadFeed() async {
    await _firebase.collection('Bugs').add({
      'UserName': _nameControler.text,
      'EmailUser': _emailControler.text,
      'Description': descripUser,
      'Date': date,
      'caty': selected,
    }).then((value) {
      setState(() {
        _descripControler.clear();
        descripUser = '';
      });
      showToast(context, color: Colors.green, message: 'Thank you 😄');
    }, onError: (e) {
      showToast(context, color: Colors.redAccent, message: '$e');
    });
  }

  Future<void> getInfuUser() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      await _firebase
          .collection('Users')
          .document(user.uid)
          .get()
          .then((value) {
        setState(() {
          _nameControler.text = value['userName'];
          _emailControler.text = value['email'];
        });
      });
    } else {
      print('User not logIn');
    }
  }

  @override
  void initState() {
    getInfuUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ToolbareNews(
              assetImage: 'help.svg',
              title: 'Help!?',
            ),
            Flexible(
              child: ListView(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CardRawContainer(
                        cardChild: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: DropdownButton<String>(
                              isExpanded: true,
                              underline: SizedBox(),
                              hint: DropMenuButtons(
                                label: '$selected',
                                image: selected == 'Bug'
                                    ? 'bug.svg'
                                    : 'feedback.svg',
                              ),
                              items: [
                                DropdownMenuItem(
                                  child: DropMenuButtons(
                                    label: 'FeedBack',
                                    image: 'feedback.svg',
                                  ),
                                  value: 'FeedBack',
                                ),
                                DropdownMenuItem(
                                  child: DropMenuButtons(
                                    label: 'Bug',
                                    image: 'bug.svg',
                                  ),
                                  value: 'Bug',
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selected = value;
                                });
                              }),
                        ),
                      )),
                      Expanded(
                          child: CardRawContainer(
                        cardChild: Center(
                          child: Text(
                            '$date',
                            style: kStyleScore,
                          ),
                        ),
                      )),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    width: mSize.width,
                    child: CardRawContainer(
                      cardChild: Center(
                        child: TextField(
                          controller: _nameControler,
                          decoration: InputDecoration(
                              hintText: 'your name',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15.0)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0.0),
                    width: mSize.width,
                    child: CardRawContainer(
                      cardChild: Center(
                        child: TextField(
                          controller: _emailControler,
                          decoration: InputDecoration(
                              hintText: 'your email',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15.0)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    width: mSize.width,
                    height: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: kBlureCont5,
                        boxShadow: [kShadow1]),
                    child: TextField(
                      controller: _descripControler,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'descrip...',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0)),
                      onChanged: (value) {
                        setState(() {
                          descripUser = value;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CardSmallGreenRed(
                        color: Colors.redAccent,
                        label: 'Discard',
                        onPress: () {
                          setState(() {
                            _descripControler.clear();
                            _emailControler.clear();
                            _nameControler.clear();
                            descripUser = '';
                          });
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      CardSmallGreenRed(
                        color: Colors.green,
                        label: 'Send',
                        onPress: () {
                          if (descripUser.toString() != '' &&
                              _emailControler.text.toString() != '' &&
                              _nameControler.text.toString() != '') {
                            uploadFeed();
                          } else {
                            showToast(context,
                                message: 'Please fill all infu',
                                color: Colors.deepOrangeAccent);
                          }
                        },
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

class CardSmallGreenRed extends StatelessWidget {
  final color;
  final label;
  final onPress;

  CardSmallGreenRed({this.color, this.label, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: FlatButton(
          onPressed: onPress,
          color: color,
          textColor: Colors.white,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                '$label',
                style: TextStyle(
                    fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
              ))),
    );
  }
}

class DropMenuButtons extends StatelessWidget {
  final image;
  final label;

  DropMenuButtons({@required this.image, @required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'images/$image',
          height: 30.0,
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          '$label',
          style: kStyleNameTeams.copyWith(fontSize: 18.0),
        ),
      ],
    );
  }
}

class CardRawContainer extends StatelessWidget {
  final cardChild;
  CardRawContainer({@required this.cardChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: kBlureCont5,
          boxShadow: [kShadow1]),
      child: cardChild,
    );
  }
}
