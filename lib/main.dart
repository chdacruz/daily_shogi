import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'miniShogi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 40, right: 40, bottom: 60, top: 60),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(30),
                  color: Colors.white,
                  child: Center(
                      child: Container(
                        child: Text('Daily Shogi', style: TextStyle(color: Colors.black, fontSize: 30)),
                      )
                  ),
                ),
              )
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MiniShogiScreen()), //Code to go to the next page
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
                          primary: Colors.blueAccent, elevation: 2.0),
                      onPressed: null,
                      child: Text('Play Mini Shogi', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    MiniShogiScreen() //Code to go to the next page
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
                      style: TextButton.styleFrom(primary: Colors.blueAccent, elevation: 2.0),
                      onPressed: null,
                      child: Text('Play Shogi', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
            ),
          )
          ],
      ),
    );
  }
}
