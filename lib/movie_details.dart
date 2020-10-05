import 'package:flutter/material.dart';
import 'package:movie/main.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/SimilarMovies.dart';
import 'package:movie/Cast.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:movie/AdMobService.dart';

class DetailsById {
  String backdropPath;
  String posterPath;
  int budget;
  int id;
  String overview;
  double popularity;
  String releaseDate;
  int revenue;
  int runtime;
  String title;
  double voteAverage;
  int voteCount;

  DetailsById(
      {this.title,
      this.posterPath,
      this.backdropPath,
      this.budget,
      this.id,
      this.overview,
      this.popularity,
      this.releaseDate,
      this.revenue,
      this.runtime,
      this.voteAverage,
      this.voteCount});

  factory DetailsById.fromJson(Map<String, dynamic> json) {
    return DetailsById(
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      budget: json['budget'],
      id: json['id'],
      overview: json['overview'],
      popularity: json['popularity'],
      releaseDate: json['release_date'],
      revenue: json['revenue'],
      runtime: json['runtime'],
      title: json['title'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
    );
  }
}

class MovieDetails extends StatefulWidget {
  final int movieid;
  MovieDetails(this.movieid);
  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  final ams = AdMobService();

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    Admob.initialize(ams.getAdMobAppId());
  }

  List data;
  String image = 'https://image.tmdb.org/t/p/w780';
  String image1 = 'http://image.tmdb.org/t/p/w185';
  Future<DetailsById> getData() async {
    final response = await http.get(
        "https://api.themoviedb.org/3/movie/${widget.movieid}?api_key=54a91f8f6f10791019cbee06394e04a8&language=en-US");
    if (response.statusCode == 200) {
      return DetailsById.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error occured");
    }
  }

  List dataone;
  Future<List> getdataone() async {
    var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movieid}/similar?api_key=54a91f8f6f10791019cbee06394e04a8&language=en-US&page=1'),
    );

    var resBody = json.decode(res.body);
    return dataone = resBody["results"];
  }

  List datagenre;
  Future<List> getdatagenre() async {
    var res = await http.get(
      Uri.parse(
          'http://api.themoviedb.org/3/movie/${widget.movieid}?api_key=54a91f8f6f10791019cbee06394e04a8&append_to_response=videos'),
    );

    var resBody = json.decode(res.body);
    return datagenre = resBody["genres"];
  }

  List datacast;
  Future<List> getdatacast() async {
    var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movieid}/credits?api_key=54a91f8f6f10791019cbee06394e04a8'),
    );

    var resBody = json.decode(res.body);
    return datacast = resBody["cast"];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DetailsById>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            //0xFFF1EFF1
            backgroundColor: Colors.black, //0xFF035AA6
            body: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 350,
                      child: Stack(
                        children: <Widget>[
                          ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black, Colors.transparent],
                              ).createShader(Rect.fromLTRB(
                                  0, 170, rect.width, rect.height));
                            },
                            blendMode: BlendMode.dstIn,
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/backdrop.jpg',
                              image: snapshot.data.backdropPath == null
                                  ? 'assets/images/backdrop.jpg'
                                  : image + snapshot.data.backdropPath,
                              height: 240,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            top: 50,
                            left: 25,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()),
                                );
                              },
                              iconSize: 35,
                            ),
                          ),
                          Positioned(
                            top: 80,
                            left: 25,
                            child: Builder(
                              builder: (BuildContext context) {
                                return OfflineBuilder(
                                  connectivityBuilder: (BuildContext context,
                                      ConnectivityResult connectivity,
                                      Widget child) {
                                    final bool connected =
                                        connectivity != ConnectivityResult.none;
                                    return AnimatedContainer(
                                      height: 30,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      color: connected
                                          ? Colors.transparent
                                          : Color(0xFFEE4400),
                                      child: connected
                                          ? Container(
                                              height: 0,
                                              width: 0,
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "Waiting for Internet Connectivity",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                SizedBox(
                                                  width: 12.0,
                                                  height: 12.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    );
                                  },
                                  child: Container(
                                    height: 0,
                                    width: 0,
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 200,
                            left: 25,
                            child: Container(
                              height: 150,
                              width: 100,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: snapshot.data.posterPath == null
                                      ? AssetImage('assets/images/poster.jpg')
                                      : NetworkImage(
                                          image1 + snapshot.data.posterPath),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 160,
                            left: 5,
                            right: 5,
                            child: Center(
                              child: Text(
                                snapshot.data.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.2),
                                  fontFamily: 'OpenSans',
                                  fontSize: 27,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 230,
                            left: 155,
                            right: 20,
                            child: FutureBuilder(
                              future: getdatagenre(),
                              builder: (context, snapss) {
                                if (snapss.hasData) {
                                  if (datagenre.length == 0) {
                                    return Container(
                                      width: 0,
                                      height: 0,
                                    );
                                  }
                                  if (datagenre.length == 1) {
                                    return Center(
                                        child: Text(
                                      datagenre[0]["name"],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ));
                                  } else if (datagenre.length >= 2) {
                                    return Center(
                                        child: Text(
                                      datagenre[0]["name"] +
                                          " / " +
                                          datagenre[1]["name"],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ));
                                  }
                                } else {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            ),
                            // child: Text('yeds',style: TextStyle(color: Colors.white),),
                          ),
                          Positioned(
                            top: 270,
                            left: 155,
                            right: 15,
                            child: Container(
                              height: 29,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text(
                                  snapshot.data.releaseDate == ""
                                      ? 'N/A'
                                      : ("Release : " +
                                          (snapshot.data.releaseDate
                                              .substring(8, 10)) +
                                          "-" +
                                          (snapshot.data.releaseDate
                                              .substring(5, 7)) +
                                          "-" +
                                          (snapshot.data.releaseDate
                                              .substring(0, 4))),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF20BF55),
                                    Color(0xFF01BAEF),
                                  ],
                                ),
                                color: Color(0xFFF1EFF1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            left: 150,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        snapshot.data.voteAverage.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFFDD00),
                                        Color(0xFFFBB034)
                                      ],
                                    ),
                                    color: Color(0xFFF1EFF1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        snapshot.data.runtime.toString() ==
                                                0.toString()
                                            ? 'N/A'
                                            : snapshot.data.runtime.toString() +
                                                ' m',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFFDD00),
                                        Color(0xFFFBB034),
                                      ],
                                    ),
                                    color: Color(0xFFF1EFF1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF035AA6),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            )),
                        margin: EdgeInsets.only(top: 10),
                        height: 690,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 10,
                              child: Container(
                                color: Colors.transparent,
                                child: AdmobBanner(
                                  adUnitId: ams.getBannerAdId(),
                                  adSize: AdmobBannerSize.FULL_BANNER,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 85,
                              left: 30,
                              right: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      child: TabBar(
                                        indicatorColor: Color(0xFF035AA6),
                                        controller: _controller,
                                        tabs: <Widget>[
                                          Container(
                                            child: Tab(
                                              child: Text(
                                                'Summary',
                                                style: TextStyle(
                                                    color: Color(0xFF035AA6),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Tab(
                                              child: Text(
                                                'Cast',
                                                style: TextStyle(
                                                    color: Color(0xFF035AA6),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 205,
                                      child: TabBarView(
                                        controller: _controller,
                                        children: <Widget>[
                                          Center(
                                            child: Scrollbar(
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  child: Text(
                                                    snapshot.data.overview == ""
                                                        ? 'No Data Available'
                                                        : snapshot
                                                            .data.overview,
                                                    style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: FutureBuilder(
                                                future: getdatacast(),
                                                builder: (context, snaps) {
                                                  if (snaps.hasData) {
                                                    if (datacast.length == 0) {
                                                      return Container(
                                                        child: Center(
                                                          child: Text(
                                                            "No Cast Details",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          datacast.length,
                                                      itemBuilder: (context,
                                                              index) =>
                                                          MovieCast(index,
                                                              widget.movieid),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child: Container(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  }
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 350,
                              left: 30,
                              right: 30,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: Center(
                                        child: Text(
                                          "Budget: " +
                                              (snapshot.data.budget
                                                          .toString() ==
                                                      0.toString()
                                                  ? 'N/A'
                                                  : "\$" +
                                                      (double.tryParse(snapshot
                                                                  .data.budget
                                                                  .toString()) /
                                                              1000000)
                                                          .toString() +
                                                      " M"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF035AA6)),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2.0,
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                          colors: [Colors.white, Colors.white],
                                        ),
                                        color: Color(0xFFF1EFF1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 22,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: Center(
                                        child: Text(
                                          "Revenue: " +
                                              (snapshot.data.revenue
                                                          .toString() ==
                                                      0.toString()
                                                  ? 'N/A'
                                                  : "\$" +
                                                      (double.tryParse(snapshot
                                                                  .data.revenue
                                                                  .toString()) /
                                                              1000000)
                                                          .toString() +
                                                      " M"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF035AA6)),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2.0,
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                          colors: [Colors.white, Colors.white],
                                        ),
                                        color: Color(0xFFF1EFF1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 400,
                              left: 35,
                              child: Text(
                                "Similar Movies",
                                style: TextStyle(
                                    color: Color(0xFFF1EFF1),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                    fontSize: 30),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 460, left: 30, right: 30, bottom: 0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                              ),
                              child: Scrollbar(
                                child: FutureBuilder(
                                  future: getdataone(),
                                  builder: (context, snap) {
                                    if (snap.hasData) {
                                      if (dataone.length == 0) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "No Data Available",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: dataone.length,
                                          itemBuilder: (context, index) =>
                                              SimilarMovies(
                                                  index, widget.movieid),
                                        );
                                      }
                                    } else {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "No Data Available",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
        } else {
          return SizedBox(
            height: 500.0,
            width: 500,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
