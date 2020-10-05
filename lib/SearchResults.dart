import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/movie_details.dart';
import 'package:movie/main.dart';

class SearchResults extends StatefulWidget {
  final String search;
  SearchResults(this.search);
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List data;
  Future<List> getdata() async {
    var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=54a91f8f6f10791019cbee06394e04a8&query=${widget.search}'),
    );

    var resBody = json.decode(res.body);
    return data = resBody["results"];
  }

  bool onlisttap = false;
  String image = 'http://image.tmdb.org/t/p/w185';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.search == ""
          ? AppBar(
              elevation: 0,
              title: Text("Your search box was empty :("),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(150.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Center(
                      child: Image.asset('assets/images/error.png'),
                    ),
                  )),
            )
          : AppBar(
              title: Text('Results for "' + widget.search + '"'),
              elevation: 0.0,
            ),
      backgroundColor: Color(0xFF035AA6),
      body: FutureBuilder<List>(
        future: getdata(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (data.length == 0) {
              return Container(
                  margin: EdgeInsets.only(top: 40, left: 20),
                  child: Text(
                    "No results, Please search again",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ));
            } else if (data.length >= 0) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1EFF1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: data.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              onlisttap = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetails(data[index]["id"])),
                            );
                          },
                          child: InkWell(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 15.0),
                                  height: 136,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: Colors.red,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 121.0, left: 15.0),
                                    width: 80.0,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.7),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(22),
                                        topRight: Radius.circular(22),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        data[index]["vote_average"]
                                                    .toString() ==
                                                0.toString()
                                            ? 'N/A'
                                            : data[index]["vote_average"]
                                                    .toString() +
                                                "/10",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                        right: 25.0, left: 15.0, top: 15.0),
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF035AA6),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(22),
                                        topLeft: Radius.circular(22),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        data[index]["title"],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                Positioned(
                                  height: 106,
                                  top: 45.0,
                                  right: 24.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(22),
                                    ),
                                    child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/poster.jpg',
                                        image:
                                            data[index]["poster_path"] == null
                                                ? 'assets/images/poster.jpg'
                                                : image +
                                                    data[index]["poster_path"]),
                                  ),
                                ),
                                Positioned(
                                  height: 76,
                                  width: 80.0,
                                  top: 45.0,
                                  left: 15.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        data[index]["release_date"] == ""
                                            ? 'N/A'
                                            : data[index]["release_date"]
                                                .toString()
                                                .substring(0, 4),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  height: 106,
                                  top: 45.0,
                                  left: 120.0,
                                  right: 120.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                            text: data[index]["overview"] == ""
                                                ? 'Data Not Available'
                                                : (data[index]["overview"]
                                                            .toString()
                                                            .length <=
                                                        40
                                                    ? data[index]["overview"]
                                                        .toString()
                                                    : data[index]["overview"]
                                                        .toString()
                                                        .substring(0, 40)),
                                            style: TextStyle(
                                              color: Color(0xFF035AA6)
                                                  .withOpacity(0.7),
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(text: ('    ')),
                                              TextSpan(
                                                text: data[index]["overview"] ==
                                                        ""
                                                    ? '..know more'
                                                    : '..read more',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 10.0),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return SizedBox(
              height: 250,
              width: 250,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getdata();
  }
}
