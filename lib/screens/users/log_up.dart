import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kooramd/constants.dart';
import 'package:kooramd/screens/users/login_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LogUpUser extends StatefulWidget {
  final Function onCompletSignIn;

  LogUpUser({@required this.onCompletSignIn});

  @override
  _LogUpUserState createState() => _LogUpUserState();
}

class _LogUpUserState extends State<LogUpUser> {
  var email;
  var password;
  var name;
  bool _onProgress = false;

  final firebaseAuth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  File _image;
  String _imageProfileUrl = '';

  Future<String> getUserUid() async {
    final FirebaseUser user = await firebaseAuth.currentUser();

    if (user != null) {
      print('User is SignUp');
      widget.onCompletSignIn();

      return user.uid.toString();
    } else {
      print('User not SignUp');
      return 'null';
    }
  }

  Future<dynamic> saveDataUserToStore() async {
    final userUid = await getUserUid();
    if (userUid == 'null') {
      print('User cureentUser is null');
      setState(() {
        _onProgress = false;
      });
    } else {
      setState(() {
        _onProgress = true;
      });
      final imageUser = await uploadFile();
      await _fireStore
          .collection('Users')
          .document(userUid)
          .setData({
            'userName': name,
            'email': email,
            'password': password,
            'imageProfile': imageUser,
            'user': userUid,
          })
          .then((value) => {
                print('Data is In firestore '),
                setState(() {
                  _onProgress = false;
                }),
                //hide bottomSheet
                Navigator.pop(context),
              })
          .catchError(
            (onError) {
              print('Error: $onError');
              showToast(context, message: onError, color: Colors.red);
              setState(() {
                _onProgress = false;
              });
            },
          );
    }
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future<String> uploadFile() async {
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
        _imageProfileUrl = downloadUrl1;
      });
      return _imageProfileUrl;
    }
    return '';
  }

  Widget showDialogLogIn(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: LogInUser(onCompletSignIn: widget.onCompletSignIn),
      ),
    );
  }

  var heightSheet;
  void setHeightSheet(BuildContext context) {
    heightSheet = MediaQuery.of(context).size.height / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightSheet,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFF787878),
      ),
      child: ModalProgressHUD(
        inAsyncCall: _onProgress,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          decoration: BoxDecoration(
            color: kColorPrimaryDark,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                ImageProfileUser(
                  onPress: () {
                    //do
                    chooseFile();
                  },
                  imageProfile: _imageProfileUrl,
                  imageFile: _image,
                ),
                SizedBox(
                  height: 10.0,
                ),
                KStyleTextFaild(
                  childCard: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'your Name',
                      contentPadding: EdgeInsets.only(bottom: 5.0),
                    ),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: kColorPrimaryDark, fontFamily: 'Tajawal'),
                    keyboardType: TextInputType.text,
                    onChanged: (newValue) {
                      name = newValue;
                    },
                  ),
                ),
                KStyleTextFaild(
                  childCard: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'email',
                      contentPadding: EdgeInsets.only(bottom: 5.0),
                    ),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: kColorPrimaryDark, fontFamily: 'Tajawal'),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (newValue) {
                      email = newValue;
                    },
                  ),
                ),
                KStyleTextFaild(
                  childCard: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'password',
                      contentPadding: EdgeInsets.only(bottom: 5.0),
                    ),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: kColorPrimaryDark, fontFamily: 'Tajawal'),
                    obscureText: true,
                    onChanged: (newValue) {
                      password = newValue;
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    color: kColorPrimary,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    onPressed: () {
                      //do
                      FocusScope.of(context).requestFocus(FocusNode());
                      //do
                      if (email != null && password != null) {
                        setState(() {
                          _onProgress = true;
                          setHeightSheet(context);
                        });
                        uploadFile();
                        firebaseAuth
                            .createUserWithEmailAndPassword(
                                email: email, password: password)
                            .then((value) => {
                                  saveDataUserToStore(),
                                })
                            .catchError(
                          (error) {
                            print('Error: $error');
                            showToast(context,
                                message: error, color: Colors.red);
                            setState(() {
                              _onProgress = false;
                              heightSheet = null;
                            });
                          },
                        );
                      } else {
                        showToast(context,
                            message: 'Please enter a real infu',
                            color: kColorPrimary);
                      }
                    },
                    child: Center(
                      child: Text(
                        'SignUp',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'you have an Account!? Log in directly',
                  style: TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: showDialogLogIn,
                    );
                  },
                  child: Text('LogIn',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0,
                        fontFamily: 'Tajawal',
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageProfileUser extends StatelessWidget {
  final imageProfile;
  final imageFile;
  final Function onPress;

  ImageProfileUser(
      {@required this.imageProfile,
      @required this.onPress,
      @required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 2.0),
          height: 93.0,
          width: 100.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: imageFile == null
              ? Center(
                  child: Icon(
                  Icons.image,
                  color: kColorPrimaryDark,
                  size: 40.0,
                ))
              : ShowImageProfile(image: imageFile)),
    );
  }
}

class ShowImageProfile extends StatelessWidget {
  final image;
  ShowImageProfile({@required this.image});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      image: DecorationImage(
        image: FileImage(image),
        fit: BoxFit.cover,
      ),
    ));
  }
}
