import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumList extends StatelessWidget {
  final callback;

  AlbumList(this.callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("albums").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text("There are no albums!");
            final List<DocumentSnapshot> albums = snapshot.data.docs;
            return ListView.builder(
                itemCount: albums.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: Album(albums[index].data()['image'],
                        albums[index].data()['title'], callback),
                  );
                });
          }),
    );
  }
}

class Album extends StatelessWidget {
  final image;
  final title;
  final callback;
  Album(this.image, this.title, this.callback);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            callback(title);
          },
          child: Container(
            height: 120.0,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(image, width: 150, fit: BoxFit.cover)),
                Positioned(
                  right: 16.0,
                  top: 16.0,
                  child: Icon(
                    Icons.bookmark,
                    color: Colors.white.withOpacity(0.6),
                    size: 24.0,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        )
      ],
    );
  }
}
