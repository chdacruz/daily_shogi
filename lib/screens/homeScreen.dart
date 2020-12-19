import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'miniShogi.dart';
import '../services/userService.dart';

class HomeScreen extends StatefulWidget {
  @override
  _MainHomeScreen createState() => _MainHomeScreen();
}

class _MainHomeScreen extends State<HomeScreen> {

  //Firebase
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

  Widget _playButton(String btnText, StatefulWidget gotoScreen) {
    return GestureDetector(
      onTap: () {
        loginAuth(_scaffoldKey, _currentUser);
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
}