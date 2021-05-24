import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:music_player/track/track.dart';

import 'homepage.dart';
import 'album/albumPage.dart';

class CustomRoute extends StatefulWidget {
  final VoidCallback onSignedOut;
  CustomRoute({this.onSignedOut});
  @override
  _CustomRouteState createState() => _CustomRouteState();
}

class _CustomRouteState extends State<CustomRoute> {
  String _title = "", _artist = "", _image = "", _url = "";

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      body: WillPopScope(
        onWillPop: () async {
          if (_navigatorKey.currentState.canPop()) {
            _navigatorKey.currentState.pop();
            return false;
          }
          return true;
        },
        child: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            // Manage your route names here
            switch (settings.name) {
              case '/':
                builder = (BuildContext context) => MyHomePage(
                      _navigatorKey,
                      (title, artist, image, url) => setState(() => {
                            _title = title,
                            _artist = artist,
                            _image = image,
                            _url = url
                          }),
                      widget.onSignedOut,
                    );
                break;
              case '/album':
                builder = (BuildContext context) => AlbumPage(
                      settings.arguments,
                      (title, artist, image, url) => setState(() => {
                            _title = title,
                            _artist = artist,
                            _image = image,
                            _url = url
                          }),
                    );
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            // You can also return a PageRouteBuilder and
            // define custom transitions between pages
            return MaterialPageRoute(
              builder: builder,
              settings: settings,
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        child: Miniplayer(
          minHeight: 75,
          maxHeight: _screenSize.height,
          builder: (height, percentage) {
            return DetailedScreen(_title, _artist, _image, _url, height);
          },
        ),
      ),
    );
  }
}
