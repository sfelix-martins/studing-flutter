import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:giphy_share/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;

  int _limit = 19;
  int _offSet = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<Map> _getGIFs() async {
    final http.Response response = await _requestGIFs();

    return json.decode(response.body);
  }

  void _searchGIFs(String value) {
    setState(() {
      _search = value;
      _offSet = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'images/giphy.gif',
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[_buildSearchGIFsSection(), _buildGIFsSection()],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    }

    return data.length + 1;
  }

  Widget _buildGIFsGridView(BuildContext context, AsyncSnapshot<Map> snapshot) {
    return GridView.builder(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot.data['data']),
        itemBuilder: (context, index) {
          final String gifUrl =
              snapshot.data['data'][index]['images']['fixed_height']['url'];
          if (_search == null || index < snapshot.data['data'].length) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        GifPage(snapshot.data['data'][index])));
              },
              onLongPress: () {
                Share.share(gifUrl);
              },
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(gifUrl),
                fit: BoxFit.cover,
              ),
            );
          }
          return _buildLoadMoreGIFsButton();
        });
  }

  Widget _buildGIFsSection() {
    return Expanded(
        child: FutureBuilder<Map>(
            future: _getGIFs(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      strokeWidth: 5.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Container(
                        alignment: Alignment.center, child: Text('Error!'));
                  }
                  return _buildGIFsGridView(context, snapshot);
              }
            }));
  }

  Widget _buildSearchGIFsSection() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: _searchGIFs,
        style: TextStyle(color: Colors.white, fontSize: 18.0),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            labelText: 'Search here',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
      ),
    );
  }

  Widget _buildLoadMoreGIFsButton() {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _offSet += _limit;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add,
              color: Colors.white,
              size: 50,
            ),
            Text(
              'Load more...',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  Future<http.Response> _requestGIFs() async {
    if (_search == null || _search.isEmpty) {
      return await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=uJJnhphTR8RWwF7aztNbMD6gv9SOFMeU&limit=${_limit + 1}&rating=G');
    }
    return await http.get(
        "https://api.giphy.com/v1/gifs/search?api_key=uJJnhphTR8RWwF7aztNbMD6gv9SOFMeU&q=$_search&limit=$_limit&offset=$_offSet&rating=G&lang=en");
  }
}
