import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kooramd/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kooramd/screens/users/log_up.dart';
import 'package:kooramd/widgets/vote_users_list.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;

class VoteScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final uid_luege;
  final dateMatche;
  // ignore: non_constant_identifier_names
  final document_id_match;
  final logoHome, logoAway;
  VoteScreen(
      // ignore: non_constant_identifier_names
      {this.uid_luege,
      this.dateMatche,
      // ignore: non_constant_identifier_names
      this.document_id_match,
      @required this.logoAway,
      @required this.logoHome});

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser loggedInUser;
TextEditingController controller = TextEditingController();

class _VoteScreenState extends State<VoteScreen> {
  final _firebase = Firestore.instance;

  final mDataUser = Firestore.instance;
  final mDataVote = Firestore.instance;
  bool _onProgress = false;

  var userMessage = '';
  var userUid;
  var voteAway = 0;
  var voteHome = 0;

  Future<void> _getCurrentUser() async {
    var user = await _auth.currentUser();
    if (user != null) {
      //hide keyboard
      FocusScope.of(context).requestFocus(new FocusNode());
      print('User is logIn');
      loggedInUser = user;
      userUid = loggedInUser.uid;
      checkIfUserBanned(userUid);
    } else {
      print('User not logIn');
      showToast(context, message: 'Please login first', color: Colors.red);
      //show BottomSheet to sign Up pr Sign In
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: showDialogLogIn,
      );
    }
  }

  Future<void> checkIfUserBanned(userUid) async {
    await _firebase.collection('Users').document(userUid).get().then((value) {
      if (value['banned'] == 'true') {
        showToast(context,
            message: 'This Account has Banned. please email the report.');
        Navigator.pop(context);
      } else {
        saveVoteToDatabase();
      }
    });
  }

  Future<void> saveVoteToDatabase() async {
    setState(() {
      _onProgress = true;
    });
    var nameUser;
    var imageProfile;
    await mDataUser
        .collection('Users')
        .document(userUid)
        .get()
        .then((value) => {
              nameUser = value['userName'],
              imageProfile = value['imageProfile'],
            })
        .catchError((onError) {
      print('Error: $onError');
      setState(() {
        _onProgress = false;
      });
      throw '$onError';
    });

    await mDataVote
        .collection('Lueges')
        .document(widget.uid_luege)
        .collection('Date')
        .document(widget.dateMatche)
        .collection('Matches')
        .document(widget.document_id_match)
        .collection('VoteUsers')
        .document(userUid)
        .setData({
      'nameUser': nameUser,
      'imageProfile': '$imageProfile',
      'voteHome': '$voteHome',
      'voteAway': '$voteAway',
      'userUid': userUid,
      'message': userMessage,
      'date': DateTime.now().millisecondsSinceEpoch,
    }).catchError((onError) {
      print('Error while posting vote: $onError');
      showToast(context, message: onError, color: Colors.red);
      setState(() {
        _onProgress = false;
      });
    }).then((value) => {
              print('Complet posting...'),
              controller.clear(),
              setState(() {
                _onProgress = false;
              }),
              Navigator.pop(context),
            });
  }

  Widget showDialogLogIn(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: LogUpUser(
          onCompletSignIn: _getCurrentUser,
        ),
      ),
    );
  }

  void showDialogVote() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: kColorPrimaryDark,
            contentPadding: EdgeInsets.all(0.0),
            // titlePadding: EdgeInsets.all(5.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text('You have the right to only one vote.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: 'Tajawal',
                    )),
              ],
            ),
            content: RawButtonEnterVote(
              logoHome: widget.logoHome,
              logoAway: widget.logoAway,
              scoreAwayShoosen: (away) {
                setState(() {
                  voteAway = away;
                });
              },
              scoreHomeShoosen: (home) {
                setState(() {
                  voteHome = home;
                });
              },
              messageVote: (newMessage) {
                setState(() {
                  userMessage = newMessage;
                });
              },
              onPress: () {
                //check if user logIn
                _getCurrentUser();
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogVote();
        },
        backgroundColor: kColorPrimary,
        child: Icon(
          Icons.file_upload,
          color: Colors.white,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _onProgress,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          width: mSize.width,
          height: mSize.height,
          child: StreamBuilder<QuerySnapshot>(
              stream: mDataVote
                  .collection('Lueges')
                  .document(widget.uid_luege)
                  .collection('Date')
                  .document(widget.dateMatche)
                  .collection('Matches')
                  .document(widget.document_id_match)
                  .collection('VoteUsers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final mVotes = snapshot.data.documents.reversed;
                List<CardVotesUsers> mListVotes = [];

                for (var vote in mVotes) {
                  mListVotes.add(
                    CardVotesUsers(
                      logoAway: widget.logoAway,
                      logoHome: widget.logoHome,
                      date: vote.data['date'],
                      messageUser: vote.data['message'],
                      userName: vote.data['nameUser'],
                      voteAway: vote.data['voteAway'],
                      voteHome: vote.data['voteHome'],
                      imageProfile: vote.data['imageProfile'],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: mListVotes.length,
                  itemBuilder: (context, index) {
                    return mListVotes[index];
                  },
                  separatorBuilder: (context, index) {
                    if (index % 4 == 3) {
                      return WidgetesAdmob.showNativeFacebookBanner();
                    }
                    return Container();
                  },
                );
              }),
        ),
      ),
    );
  }
}

class RawButtonEnterVote extends StatelessWidget {
  final Function onPress;
  final logoHome;
  final logoAway;
  final Function scoreAwayShoosen;
  final Function scoreHomeShoosen;
  final Function messageVote;

  RawButtonEnterVote({
    this.onPress,
    @required this.logoAway,
    @required this.logoHome,
    @required this.scoreAwayShoosen,
    @required this.scoreHomeShoosen,
    @required this.messageVote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      //  width: double.infinity,
      color: kColorPrimaryDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image(
                    image: NetworkImage('$logoHome'),
                    width: 40.0,
                    height: 40.0,
                  ),
                  ScroleNumberVote(scoreShoosen: scoreHomeShoosen),
                  Text('VS', style: kStyleScore.copyWith(color: Colors.white)),
                  ScroleNumberVote(scoreShoosen: scoreAwayShoosen),
                  Image(
                    image: NetworkImage('$logoAway'),
                    width: 40.0,
                    height: 40.0,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 40.0,
            color: kColorPrimary,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    color: kColorPrimary,
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    onPressed: onPress),
                Expanded(
                  child: TextField(
                    maxLength: 30,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'message...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Tajawal',
                      ),
                      //  isDense: true,
                      contentPadding: EdgeInsets.only(bottom: 5.0),
                      border: InputBorder.none,
                      alignLabelWithHint: false,
                      counter: Offstage(),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontFamily: 'Tajawal',
                    ),
                    onChanged: messageVote,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ScroleNumberVote extends StatelessWidget {
  ScroleNumberVote({@required this.scoreShoosen});
  final Function scoreShoosen;

  List<int> mListScore = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      child: CupertinoPicker.builder(
        itemExtent: 25,
        onSelectedItemChanged: scoreShoosen,
        itemBuilder: (context, index) {
          return Container(
              child: Text('${mListScore[index]}', style: kStyleScoreVote));
        },
        childCount: mListScore.length,
      ),
    );
  }
}
