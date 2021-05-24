import 'package:flutter/material.dart';

import '../track/songList.dart';

var bgColor = Color(0xFF111111);
var pinkColor = Color(0xFFff6b80);

class AlbumPage extends StatefulWidget {
  final album;
  final Function callback;

  AlbumPage(this.album, this.callback);

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(
            children: [
              Text(
                widget.album,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 38.0),
              ),
              SizedBox(height: 16.0),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
                  child: SongList(widget.callback, widget.album)),
            ],
          )),
    );
  }
}
