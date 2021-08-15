import 'package:flutter/material.dart';

import 'track/songList.dart';
import 'album/album.dart';
import 'search.dart';
import 'auth/auth.dart';
import 'auth/auth_provider.dart';
import 'auth/logout.dart';

var bgColor = Color(0xFF111111);
var pinkColor = Color(0xFFff6b80);

class MyHomePage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Function callback;
  final VoidCallback onSignedOut;
  MyHomePage(this.navigatorKey, this.callback, this.onSignedOut);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  String greetings() {
    DateTime now = DateTime.now();
    int hours = now.hour;

    if (hours < 12)
      return "Morning";
    else if (hours < 13)
      return "Noon";
    else if (hours < 16) return "Afternoon";
    return "Evening";
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Logout(_signOut),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Welcome'),
      //   actions: <Widget>[
      //     FlatButton(
      //       child: Text('Logout',
      //           style: TextStyle(fontSize: 17.0, color: Colors.white)),
      //       onPressed: () => _signOut(context),
      //     )
      //   ],
      // ),

      backgroundColor: bgColor,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Good ' + greetings(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(_createRoute());
                      },
                    ),
                  ],
                ),
                SizedBox(height: 32.0),
                CustomTextField(),
                SizedBox(height: 32.0),
                Text(
                  'Collections',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 38.0),
                ),
                SizedBox(height: 16.0),
                AlbumList((album) => {
                      widget.navigatorKey.currentState
                          .pushNamed('/album', arguments: album)
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AlbumPage(album),
                      //   ),
                      // )
                    }),
                Text(
                  'Songs',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 38.0),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SongList(widget.callback, ""),
                SizedBox(
                  height: 100.0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
