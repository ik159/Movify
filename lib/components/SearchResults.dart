import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/components/MovieHorizontal.dart';
import 'package:movie/components/PersonDetail.dart';
import 'package:movie/components/TVDetails.dart';
import 'package:movie/components/details.dart';
import 'package:movie/components/ui.dart';

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

  List tvdata;
  Future<List> getTVdata() async {
    var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/search/tv?api_key=54a91f8f6f10791019cbee06394e04a8&query=${widget.search}'),
    );

    var resBody = json.decode(res.body);
    return tvdata = resBody["results"];
  }

  List persondata;
  Future<List> getPersondata() async {
    var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/search/person?api_key=54a91f8f6f10791019cbee06394e04a8&query=${widget.search}'),
    );

    var resBody = json.decode(res.body);
    return persondata = resBody["results"];
  }

  String image1 = 'https://image.tmdb.org/t/p/w780';
  bool onlisttap = false;
  String image = 'http://image.tmdb.org/t/p/w185';
  double height, width;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text('Results for "' + widget.search + '"'),
      ),
      backgroundColor: Colors.grey[200],
      body: widget.search == "" ? Center(child: Text("Your search box was empty :("),) :SingleChildScrollView(
              child: Column(
          children: [
            FutureBuilder<List>(
              future: getdata(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (data.length == 0) {
                    return Container(
                        margin: EdgeInsets.only(top: 40, left: 20),
                        child: Text(
                          "No Movie results",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ));
                  } else if (data.length > 0) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 7),
                                child: Text(
                                  "Movies",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFFCAC531), Color(0xFFF3F9A7)]),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.2,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetails(data[index]["id"]),
                                    ),
                                  );
                                },
                                child: InkWell(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 4.0,
                                                spreadRadius: 1.0,
                                              ),
                                            ]),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/images/backdrop.jpg',
                                            image: data[index]["backdrop_path"] ==
                                                    null
                                                ? ("assets/images/backdrop.jpg")
                                                : (image1 +
                                                    data[index]["backdrop_path"]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 15,
                                        right: 15,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: Text(
                                            data[index]["title"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 15,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              bottomLeft: Radius.circular(16),
                                            ),
                                          ),
                                          child: Text(
                                            (data[index]["release_date"] == ""
                                                ? 'N/A'
                                                : data[index]["release_date"]
                                                    .toString()
                                                    .substring(0, 4)),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return SizedBox(
                    height: 250,
                    width: 250,
                    child: Center(
                      child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),),
                    ),
                  );
                }
              },
            ),
            FutureBuilder<List>(
              future: getTVdata(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (tvdata.length == 0) {
                    return Container(
                        margin: EdgeInsets.only(top: 40, left: 20),
                        child: Text(
                          "No TV results",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ));
                  } else if (tvdata.length > 0) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 7),
                                child: Text(
                                  "TV Shows",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFFf64f59), Color(0xFF12c2e9)]),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.2,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: tvdata.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TVShowsDetails(tvdata[index]["id"])),
                      );
                                },
                                child: InkWell(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 4.0,
                                                spreadRadius: 1.0,
                                              ),
                                            ]),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/images/backdrop.jpg',
                                            image: tvdata[index]
                                                        ["backdrop_path"] ==
                                                    null
                                                ? ("assets/images/backdrop.jpg")
                                                : (image1 +
                                                    tvdata[index]
                                                        ["backdrop_path"]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 15,
                                        right: 15,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: Text(
                                            tvdata[index]["name"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 15,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              bottomLeft: Radius.circular(16),
                                            ),
                                          ),
                                          child: Text(
                                            (tvdata[index]["vote_average"]
                                                        .toString() ==
                                                    "0"
                                                ? 'N/A'
                                                : tvdata[index]["vote_average"]
                                                        .toString() +
                                                    "/10"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return SizedBox(
                    height: 250,
                    width: 250,
                    child: Center(
                      child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),),
                    ),
                  );
                }
              },
            ),
            FutureBuilder<List>(
              future: getPersondata(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (persondata.length == 0) {
                    return Container(
                        margin: EdgeInsets.only(top: 40, left: 20),
                        child: Text(
                          "No Person Results",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ));
                  } else if (persondata.length > 0) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 7),
                                child: Text(
                                  "Person",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFF19A186), Color(0xFFF2CF43)]),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.2,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: persondata.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetail(persondata[index]["id"]),
                  ),
                );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child: ClipOval(
                                          child: FadeInImage.assetNetwork(
                                              fit: BoxFit.cover,
                                              placeholder:
                                                  'assets/images/9gu9.gif',
                                              image: persondata[index]
                                                          ["profile_path"] ==
                                                      null
                                                  ? 'assets/images/9gu9.gif'
                                                  : image +
                                                      persondata[index]
                                                          ["profile_path"]),
                                        ),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2.0)),
                                      ),
                                      Text(
                                        persondata[index]["name"] == null
                                            ? "N/A"
                                            : persondata[index]["name"],
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return SizedBox(
                    height: 250,
                    width: 250,
                    child: Center(
                      child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.home,
          color: Colors.red,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UIPage()),
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
