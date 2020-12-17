import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'miniShogi.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  //Begin Firebase
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser _currentUser;

  //To show snackbar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    //Called whenever the login changes
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      _currentUser = user;
    });
  }

  Future<FirebaseUser> _getUser() async {
    //If not null
    if (_currentUser != null) return _currentUser;

    //If null, begin login
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
          .authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      //To login with another provider (Facebook for instance) just inform its credential
      final AuthResult authResult = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final FirebaseUser user = authResult.user;

      return user;
    } catch (error) {
      return null;
    }
  }

  //Method that actually log in
  Future<void> loginAuth() async {
    final FirebaseUser user = await _getUser();
    Map<String, dynamic> data;

    if (user == null) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Não foi possível efetuar o login. Tente Novamente"),
            backgroundColor: Colors.red,
          )
      );
    } else {
      data = {
        "uid": user.uid,
        "email": user.email,
        "name": user.displayName,
        "photoUrl": user.photoUrl
      };

      //Checks if user already exists
      DocumentReference docRef = Firestore.instance.collection('users').document(user.uid);

      docRef.get().then((u) {
        if (!u.exists) Firestore.instance.collection("users").document(user.uid).collection("userDetails").add(data);
      });
    }
  }
    //End Firebase

    Widget _playButton(String btnText, StatefulWidget gotoScreen) {
      return GestureDetector(
        onTap: () {
          loginAuth();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => gotoScreen //Code to go to the next page
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 60),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(30),
              color: Colors.white,
              child: Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.blueAccent,
                      elevation: 2.0,
                      backgroundColor: Colors.grey),
                  onPressed: null,
                  child: Text(btnText, style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.brown,
        key: _scaffoldKey,
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: 40, right: 40, bottom: 60, top: 60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(30),
                    color: Colors.white,
                    child: Center(
                        child: Container(
                          child: Text(
                              'Daily Shogi', style: TextStyle(color: Colors
                              .black, fontSize: 30)),
                        )
                    ),
                  ),
                )
            ),
            _playButton('Play Mini Shogi', MiniShogiScreen()),
            _playButton('Play Standart Shogi', MiniShogiScreen()),
          ],
        ),
      );
    }
}