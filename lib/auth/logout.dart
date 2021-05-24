import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';
import 'auth_provider.dart';

var bgColor = Color(0xFF111111);

class Logout extends StatefulWidget {
  final Function onSignOut;
  Logout(this.onSignOut);

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  String _firstName = "";
  String _lastName = "";

  void getUsername(userId) {
    FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() => {
                      _firstName = doc['firstname'],
                      _lastName = doc['lastname']
                    });
              })
            });
  }

  @override
  void didChangeDependencies() {
    final BaseAuth auth = AuthProvider.of(context).auth;
    String userId = auth.currentUser();
    getUsername(userId);
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.black),
          clipper: getClipper(),
        ),
        Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height / 4.5,
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color(0xFFff005c),
                  child: Text(
                    _firstName != ""
                        ? _firstName[0].toUpperCase() +
                            _lastName[0].toUpperCase()
                        : '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  radius: 68,
                ),
                SizedBox(height: 60.0),
                Text(
                  _firstName != "" ? _firstName + " " + _lastName : "",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 45.0),
                Container(
                    height: 45.0,
                    width: 125.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.redAccent,
                      color: Colors.red,
                      elevation: 7.0,
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: FlatButton(
                          color: Colors.black,
                          child: Text('Logout',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white)),
                          onPressed: () => widget.onSignOut(context),
                        ),
                      ),
                    ))
              ],
            ))
      ],
    ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
