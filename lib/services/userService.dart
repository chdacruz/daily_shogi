
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

//FirebaseUser _currentUser is optional
Future<FirebaseUser> getUser([FirebaseUser _currentUser]) async {
  //If not null
  if (_currentUser != null) return _currentUser;

  //If null, begin login
  try {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

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

//Method that actually logs in
Future<void> loginAuth(GlobalKey<ScaffoldState> _scaffoldKey, [FirebaseUser _currentUser]) async {
  final FirebaseUser user = await getUser(_currentUser);
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
