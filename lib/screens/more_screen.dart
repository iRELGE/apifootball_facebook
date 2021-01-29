import 'package:about/about.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:kooramd/constants.dart';
import 'package:kooramd/screens/more/help_screen.dart';
import 'package:kooramd/screens/users/log_up.dart';
import 'package:kooramd/widgets/widgets_more_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final _firebase = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  var userUid;
  var userEmail = 'exemple@gmail.com';
  var userName = 'Full Name';
  var userImage = '';
  bool userIsLogIn = false;

  void _getCurrentUser() async {
    try {
      var user = await _auth.currentUser();
      if (user != null) {
        print('User is logIn');

        loggedInUser = user;
        userUid = loggedInUser.uid;
        getInfuUser(userUid);
        //hide keybord
        FocusScope.of(context).requestFocus(new FocusNode());
      } else {
        print('User not logIn');
        setState(() {
          userIsLogIn = false;
          userEmail = 'exemple@gmail.com';
          userName = 'Full Name';
          userImage = '';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void getInfuUser(userUid) async {
    var user = await _auth.currentUser();

    await _firebase
        .collection('Users')
        .document(userUid)
        .get()
        .then((value) => {
              setState(() {
                userIsLogIn = true;
                userEmail = user.email.toString();
                userName = value['userName'].toString();
                userImage = value['imageProfile'].toString();
              })
            });
  }

  Widget showDialogLogIn(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: LogUpUser(onCompletSignIn: _getCurrentUser),
      ),
    );
  }

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPrimary,
      appBar: AppBar(
        title: Text('More Informations'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 18.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  CircleAvatar(
                    maxRadius: 36.0,
                    backgroundColor: kColorPrimaryDark,
                    child: CircleAvatar(
                      maxRadius: 34.0,
                      backgroundColor: kColorPrimaryDark,
                      backgroundImage: userImage != ''
                          ? NetworkImage('$userImage')
                          : AssetImage('images/avatar.png'),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        '$userName',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$userEmail',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Visibility(
                    visible: userIsLogIn,
                    child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.edit,
                          color: Colors.grey.withOpacity(0.5),
                          size: 18.0,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => DialogAccount(
                                    userImage: userImage,
                                    userNameOld: userName,
                                    userUid: userUid,
                                  ));
                          setState(() {
                            //
                          });
                        }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Material(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Visibility(
                        visible: !userIsLogIn,
                        child: TileButton(
                          icon: FontAwesomeIcons.user,
                          label: 'LogIn / SignUp',
                          onPress: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: showDialogLogIn,
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: userIsLogIn,
                        child: TileButton(
                          icon: FontAwesomeIcons.signOutAlt,
                          label: 'LogOut',
                          onPress: () async {
                            await _auth.signOut();
                            _getCurrentUser();
                          },
                        ),
                      ),
                      TileButton(
                        icon: FontAwesomeIcons.questionCircle,
                        label: 'Help!?',
                        onPress: () {
                          Navigator.pushNamed(context, '/help_screen');
                        },
                      ),
                      TileButton(
                        icon: FontAwesomeIcons.addressCard,
                        label: 'About us',
                        onPress: () {
                          showAboutPage(
                            context: context,
                            applicationLegalese:
                                'Copyright © Azul Mouàd, {{ 2020-07-10 }}',
                            applicationDescription: Text(kDescripABout),
                            children: <Widget>[
                              LicensesPageListTile(
                                icon: Icon(FontAwesomeIcons.userShield),
                                values: {},
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.shoppingBag),
                                title: Text('Buy this app'),
                                onTap: () async {
                                  await launch(
                                      'https://codecanyon.net/user/mouad_zizi');
                                },
                              ),
                              ListTile(
                                leading:
                                    Icon(FontAwesomeIcons.solidEnvelopeOpen),
                                title: Text('Contact Developer'),
                                onTap: () async {
                                  await launch(
                                      'mailto:moad.devloper@gmail.com');
                                },
                              ),
                            ],
                            applicationIcon: SizedBox(
                              width: 200,
                              height: 200,
                              child: SvgPicture.asset('images/soccer.svg'),
                            ),
                          );
                        },
                      ),
                      TileButton(
                        icon: FontAwesomeIcons.whatsapp,
                        label: 'Contact us',
                        onPress: () async {
                          await launch(kLinkWhatsap);
                        },
                      ),
                      TileButton(
                        icon: FontAwesomeIcons.userShield,
                        label: 'Privacy Policy',
                        onPress: () async {
                          await launch('$kLinkPrivacyPolicy');
                        },
                      ),
//                      TileButton(
//                        icon: FontAwesomeIcons.atom,
//                        label: 'GDPR',
//                        onPress: () async {
//                          await GdprDialog.instance.setConsentToUnknown();
//                          getStarted.showGDPR();
//                        },
//                      ),
                      TileButton(
                        icon: FontAwesomeIcons.heartbeat,
                        label: 'Rate App',
                        onPress: () async {
                          await launch('$kLinkRateApp');
                        },
                      ),
                      TileButton(
                        icon: FontAwesomeIcons.shareAlt,
                        label: 'Share App',
                        onPress: () async {
                          await FlutterShareMe()
                              .shareToSystem(msg: kLinkRateApp);
                        },
                      ),
                      CardFollowInstagram(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogAccount extends StatefulWidget {
  final userImage;
  final userNameOld;
  final userUid;

  DialogAccount(
      {@required this.userImage,
      @required this.userNameOld,
      @required this.userUid});

  @override
  _DialogAccountState createState() => _DialogAccountState();
}

class _DialogAccountState extends State<DialogAccount> {
  final _controllerName = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _firebase = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  var newImage;
  var _image;
  bool _onProgress = false;

  _updatePassword() async {
    _user = await _auth.currentUser();
    if (_controllerPassword.text != null &&
        _controllerPassword.text.toString() != '') {
      if (_controllerPassword.text.length >= 6) {
        try {
          await _user.updatePassword(_controllerPassword.text).then((value) {
            //step 2
            _updateNameAndImage();
          }, onError: (e) {
            print(e);
            showToast(context, message: e);
          });
        } catch (e) {
          print(e);
          showToast(context, message: e);
        }
      } else {
        showToast(context, message: 'Please enter a strong password!!');
      }
    } else {
      _updateNameAndImage();
    }
  }

  _updateNameAndImage() async {
    await uploadImage();
    if (_controllerName.text != null && _controllerName.text != '') {
      await _firebase.collection('Users').document(widget.userUid).updateData({
        'userName': _controllerName.text.toString(),
        'imageProfile': newImage ?? widget.userNameOld,
      }).then((value) {
        //do
        Navigator.pop(context);
        showToast(context, message: 'Changes updated successfully');
      }, onError: (e) {
        showToast(context, message: e);
      });
    } else {
      showToast(context,
          message: 'Couldn\'t save your name! please Enter a real name.');
    }
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future<String> uploadImage() async {
    if (_image != null) {
      setState(() {
        _onProgress = true;
      });
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('ProfileUsers/${Path.basename(_image.path)}');

      StorageUploadTask uploadTask = storageReference.putFile(_image);
      uploadTask.events.handleError((onError) {
        print('Image Uploading Error: $onError');
        showToast(context, message: onError, color: Colors.red);
        setState(() {
          _onProgress = false;
        });
      });

      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      final downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();
      setState(() {
        newImage = downloadUrl1;
      });
      return newImage;
    }
    return '';
  }

  @override
  void initState() {
    _controllerName.text = widget.userNameOld;
    setState(() {
      newImage = widget.userImage;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              chooseFile();
            },
            child: CircleAvatar(
              maxRadius: 50.0,
              backgroundColor: kColorPrimaryDark,
              child: CircleAvatar(
                maxRadius: 48.0,
                backgroundColor: kColorPrimaryDark,
                backgroundImage: _image == null
                    ? NetworkImage('$newImage')
                    : FileImage(_image),
              ),
            ),
          ),
          _onProgress == true ? LinearProgressIndicator() : SizedBox(),
          SizedBox(
            height: 5.0,
          ),
          TextField(
            controller: _controllerName,
            decoration: InputDecoration(
              hintText: '${widget.userNameOld}',
              icon: Icon(
                FontAwesomeIcons.userAlt,
                size: 18.0,
                color: kColorPrimaryDark,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'old password',
              icon: Icon(
                FontAwesomeIcons.lockOpen,
                size: 18.0,
                color: kColorPrimaryDark,
              ),
            ),
          ),
          TextField(
            controller: _controllerPassword,
            decoration: InputDecoration(
              hintText: 'new password',
              icon: Icon(
                FontAwesomeIcons.lock,
                size: 18.0,
                color: kColorPrimaryDark,
              ),
            ),
            obscureText: true,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CardSmallGreenRed(
                color: Colors.transparent,
                label: '❌',
                onPress: () {
                  Navigator.pop(context);
                },
              ),
              CardSmallGreenRed(
                color: Colors.green,
                label: 'upload',
                onPress: () {
                  //first check password in not null ignore
                  _updatePassword();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
