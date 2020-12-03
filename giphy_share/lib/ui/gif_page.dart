import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class GifPage extends StatelessWidget {
  final Map gif;

  GifPage(this.gif, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String gifUrl = gif['images']['fixed_height']['url'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          gif['title'],
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {
                Share.share(gifUrl);
              })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: NetworkImage(gifUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
