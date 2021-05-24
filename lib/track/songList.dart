import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SongList extends StatelessWidget {
  final callback;
  final album;

  SongList(this.callback, this.album);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: (album.length == 0)
            ? FirebaseFirestore.instance.collection("tracks").snapshots()
            : FirebaseFirestore.instance
                .collection("tracks")
                .where('album', isEqualTo: album)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text("There are no tracks!");
          final List<DocumentSnapshot> tracks = snapshot.data.docs;
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: tracks.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 12),
                child: SongItem(
                    tracks[index].data()['title'],
                    tracks[index].data()['artist'],
                    tracks[index].data()['image'],
                    tracks[index].data()['url'],
                    callback),
              );
            },
          );
        },
      ),
    );
  }
}

class SongItem extends StatelessWidget {
  final title;
  final artist;
  final image;
  final url;
  final callback;
  SongItem(this.title, this.artist, this.image, this.url, this.callback);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            callback(title, artist, image, url);
          },
          child: Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: 60.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 60.0,
                    width: 60.0,
                    child: Icon(
                      Icons.play_circle_filled,
                      color: Colors.white.withOpacity(0.7),
                      size: 42.0,
                    ),
                  )
                ],
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    artist,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 14.0),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.more_horiz,
                color: Colors.white.withOpacity(0.6),
                size: 32.0,
              )
            ],
          ),
        ),
      ],
    );
  }
}
