import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/components/FavouritesTab.dart';
import 'package:movie/components/cast.dart';
import 'package:movie/components/ui.dart';
import 'package:url_launcher/url_launcher.dart';
import './local_db_storage/data_map.dart';
import './local_db_storage/db_helper.dart';

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
  String video;
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
      this.voteCount,
      this.video});

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
      video: json['videos']['results'][0]['key'],
    );
  }
}

class MovieDetails extends StatefulWidget {
  final int movieid;
  MovieDetails(this.movieid);
  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  var dbHelper;
  Future<bool> check;

  String isFav = "0";

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    checkinitMovie();
  }

  checkinitMovie() {
    print("fav before is " + isFav.toString());

    dbHelper.checkMovie(0, widget.movieid).then((value) {
      print("value is " + value.toString());
      setState(() {
        isFav = value.toString();
      });
    });
    print("fav after is " + isFav.toString());
  }

  addtoFavs(int mid, int cat, int movieid) {
    Movie m = Movie(mid, cat, movieid);
    dbHelper.save(m);
  }

  List data;
  String image = 'https://image.tmdb.org/t/p/w1280';
  String image1 = 'http://image.tmdb.org/t/p/w342';
  String videoprefix = 'https://www.youtube.com/watch?v=';

  Future<DetailsById> getData() async {
    final response = await http.get(
        "https://api.themoviedb.org/3/movie/${widget.movieid}?api_key=54a91f8f6f10791019cbee06394e04a8&language=en-US&append_to_response=videos");
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

  List datamedia;
  Future<List> getmedia() async {
    var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movieid}/images?api_key=54a91f8f6f10791019cbee06394e04a8'),
    );

    var resBody = json.decode(res.body);
    return datamedia = resBody["backdrops"];
  }

  double width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return FutureBuilder<DetailsById>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.grey[200], //0xFF035AA6
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: height * 0.5,
                    width: double.infinity,
                    color: Colors.black,
                    child: Stack(
                      children: <Widget>[
                        ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black, Colors.transparent],
                            ).createShader(
                                Rect.fromLTRB(0, 170, rect.width, rect.height));
                          },
                          blendMode: BlendMode.dstIn,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/backdrop.jpg',
                            image: snapshot.data.backdropPath == null
                                ? 'assets/images/backdrop.jpg'
                                : image + snapshot.data.backdropPath,
                            height: height * 0.3,
                            fit: BoxFit.fill,
                          ),
                        ),
                       /* Positioned(
                          top: 40,
                          left: 20,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            iconSize: 40,
                            color: Colors.white,
                            onPressed: () {
                              FavouritesTab();
                              Navigator.pop(context);
                            },
                          ),
                        ),*/
                        Positioned.fill(
                          top: height * .25,
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: height * .22,
                                width: width * 0.27,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: snapshot.data.posterPath == null
                                        ? AssetImage('assets/images/poster.jpg')
                                        : NetworkImage(
                                            image1 + snapshot.data.posterPath),
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 7),
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
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ));
                                            } else if (datagenre.length >= 2) {
                                              return Center(
                                                  child: Text(
                                                datagenre[0]["name"] +
                                                    " / " +
                                                    datagenre[1]["name"],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ));
                                            }
                                          } else {
                                            return Container(
                                              height: 10,
                                              width: 10,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                          Color>(Colors.red),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 7),
                                      child: Text(
                                        snapshot.data.releaseDate == ""
                                            ? 'N/A'
                                            : ("🎥 : " +
                                                (snapshot.data.releaseDate
                                                    .substring(8, 10)) +
                                                "." +
                                                (snapshot.data.releaseDate
                                                    .substring(5, 7)) +
                                                "." +
                                                (snapshot.data.releaseDate
                                                    .substring(0, 4))),
                                        style: TextStyle(
                                            color: Colors.grey[200],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 7),
                                            child: Text(
                                              "⭐ " +
                                                  snapshot.data.voteAverage
                                                      .toString() +
                                                  "/10",
                                              style: TextStyle(
                                                  color: Colors.yellow[300],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 7),
                                            child: Text(
                                              snapshot.data.runtime
                                                          .toString() ==
                                                      0.toString()
                                                  ? 'N/A'
                                                  : '⏱️ ' +
                                                      snapshot.data.runtime
                                                          .toString() +
                                                      ' m',
                                              style: TextStyle(
                                                  color: Colors.yellow[300],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(16)),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: Column(
                        children: [
                          Text(snapshot.data.title.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                          SizedBox(
                            height: 5,
                          ),
                          snapshot.data.video == null ? Container(height: 0,): GestureDetector(
                            onTap: (){
                              launch( videoprefix + snapshot.data.video);
                            },
                                                      child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_circle_outline , color: Colors.red , size: 32),
                                SizedBox(width: 10,),
                                Text(
                                  "Play",
                                  style: TextStyle(color: Colors.grey[200]),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          isFav.toString() == "1"
                              ? GestureDetector(
                                  onTap: () {
                                    dbHelper.delete(0, widget.movieid);
                                    checkinitMovie();
                                    
                                  },
                                  child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.favorite , color: Colors.red , size: 32),
                                      SizedBox(width: 10,),
                                      Text(
                                        "Remove from Favourites",
                                        style: TextStyle(color: Colors.grey[200]),
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    addtoFavs(
                                        widget.movieid, 0, widget.movieid);
                                    checkinitMovie();
                                  },
                                  child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.favorite_border , color: Colors.red , size: 32),
                                      SizedBox(width: 10,),
                                      Text(
                                        "Add to Favourites",
                                        style: TextStyle(color: Colors.grey[200]),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    //remove Gesture Detec here
                                    onTap: () {
                                      addtoFavs(
                                          widget.movieid, 0, widget.movieid);
                                    },
                                    child: Text(
                                      "Summary",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: GestureDetector(
                                  //remove Gesture Detec here
                                  onTap: () {
                                    dbHelper.delete(0, widget.movieid);
                                  },
                                  child: Text(
                                    snapshot.data.overview == ""
                                        ? 'No Data Available'
                                        : snapshot.data.overview,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Container(
                    color: Colors.grey[200],
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Container(
                          margin:
                              EdgeInsets.only(top: 20, left: 20, bottom: 20),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Cast",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
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
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: datacast.length,
                                          itemBuilder: (context, index) =>
                                              MovieCast(
                                                  index, widget.movieid, 0),
                                        );
                                      } else {
                                        return Center(
                                          child: Container(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.red),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Container(
                    color: Colors.black,
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Container(
                          margin:
                              EdgeInsets.only(top: 20, left: 20, bottom: 20),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Media",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 120,
                                child: FutureBuilder(
                                    future: getmedia(),
                                    builder: (context, snaps) {
                                      if (snaps.hasData) {
                                        if (datamedia.length == 0) {
                                          return Container(
                                            child: Center(
                                              child: Text(
                                                "No Media Available",
                                                style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: datamedia.length,
                                          itemBuilder: (context, index) =>
                                              Container(
                                            margin: EdgeInsets.only(right: 10),
                                            height: 100,
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/images/backdrop.jpg',
                                              image: datamedia[index]
                                                          ["file_path"] ==
                                                      null
                                                  ? ("assets/images/backdrop.jpg")
                                                  : (image +
                                                      datamedia[index]
                                                          ["file_path"]),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: Container(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.red),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Container(
                    color: Colors.grey[200],
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Container(
                          margin:
                              EdgeInsets.only(top: 20, left: 20, bottom: 20),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Similar Movies",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
                                child: FutureBuilder(
                                    future: getdataone(),
                                    builder: (context, snaps) {
                                      if (snaps.hasData) {
                                        if (dataone.length == 0) {
                                          return Container(
                                            child: Center(
                                              child: Text(
                                                "No Data Available :(",
                                                style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: dataone.length,
                                          itemBuilder: (context, index) =>
                                              GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieDetails(
                                                          dataone[index]["id"]),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              height: 100,
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/images/9gu9.gif',
                                                image: dataone[index]
                                                            ["poster_path"] ==
                                                        null
                                                    ? ("assets/images/9gu9.gif")
                                                    : (image1 +
                                                        dataone[index]
                                                            ["poster_path"]),
                                              ),
                                            ),
                                          ), //Text("hello " , style: TextStyle(color: Colors.white),)
                                        );
                                      } else {
                                        return Center(
                                          child: Container(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.red),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
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
        } else {
          return SizedBox(
            height: 500.0,
            width: 500,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          );
        }
      },
    );
  }
}
