import 'package:flutter/material.dart';
import 'package:kooramd/constants.dart';
import 'package:kooramd/screens/users/log_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LogInUser extends StatefulWidget {
  final Function onCompletSignIn;

  LogInUser({@required this.onCompletSignIn});
  @override
  _LogInUserState createState() => _LogInUserState();
}

class _LogInUserState extends State<LogInUser> {
  var email;
  var password;
  bool _onProgress = false;
  final authUser = FirebaseAuth.instance;

  var heightSheet;
  void setHeightSheet(BuildContext context) {
    heightSheet = MediaQuery.of(context).size.height / 2;
  }

  Widget showDialogLogIn(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: LogUpUser(onCompletSignIn: widget.onCompletSignIn),
      ),
    );
  }

  Future getCurrentUser() async {
    FirebaseUser user = await authUser.currentUser();

    if (user != null) {
      print('User is LogIn');
      widget.onCompletSignIn();
      Navigator.pop(context);
    } else {
      print('User Not LogIn');
      setState(() {
        heightSheet = null;
      });
    }
  }

  void signInUser() {
    final userSign =
        authUser.signInWithEmailAndPassword(email: email, password: password);
    userSign.catchError((onError) {
      //do
      print('Error: $onError');
      showToast(context, message: onError, color: Colors.red);
      setState(() {
        _onProgress = false;
      });
    }).whenComplete(() => {
          //do
          print('Progress Complet'),
          getCurrentUser(),
        });
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
                Text(
                  'No account !?\nCreate a new account\nfor you to upload your own vote on every match',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                ),
                SizedBox(
                  height: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    //do
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: showDialogLogIn,
                    );
                  },
                  child: Text(
                    'SignUp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
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
                      color: kColorPrimaryDark,
                      fontFamily: 'Tajawal',
                    ),
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
                      color: kColorPrimaryDark,
                      fontFamily: 'Tajawal',
                    ),
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
                      if (email != null && password != null) {
                        setState(() {
                          _onProgress = true;
                          setHeightSheet(context);
                        });
                        signInUser();
                      } else {
                        showToast(context,
                            message: 'Please enter a real email & password',
                            color: kColorPrimary);
                      }
                    },
                    child: Center(
                      child: Text(
                        'LogIn',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 18.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
