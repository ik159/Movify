import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/components/TVDetails.dart';
import 'package:movie/components/details.dart';

class MovieHorizotal extends StatefulWidget {
  final int ind;
  final int genre;
  final String type;
  MovieHorizotal({this.ind, this.genre, this.type});
  @override
  _MovieHorizotalState createState() => _MovieHorizotalState();
}

class _MovieHorizotalState extends State<MovieHorizotal> {
  List data;
  Future<List> getdata() async {
    var res;

    if (widget.type == "movie") {
      if (widget.genre == 000) {
        res = await http.get( 
          "https://api.themoviedb.org/3/movie/now_playing?api_key=54a91f8f6f10791019cbee06394e04a8",
        );
      } else {
        res = await http.get(
          "https://api.themoviedb.org/3/discover/movie?api_key=54a91f8f6f10791019cbee06394e04a8&with_genres=${widget.genre}&sort_by=vote_count.desc",
        );
      }
    } else {
      if (widget.genre == 111113) {
        res = await http.get(
          "https://api.themoviedb.org/3/tv/popular?api_key=54a91f8f6f10791019cbee06394e04a8&language=en-US",
        );
      } else {
        res = await http.get(
          "https://api.themoviedb.org/3/discover/tv?api_key=54a91f8f6f10791019cbee06394e04a8&with_genres=${widget.genre}&sort_by=vote_count.desc",
        );
      }
    }

    var resBody = json.decode(res.body);
    return data = resBody["results"];
  }

  bool onlisttap = false;
  String image1 = 'https://image.tmdb.org/t/p/w780';
  String image = 'http://image.tmdb.org/t/p/w185';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              widget.type == "movie"
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MovieDetails(data[widget.ind]["id"])),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TVShowsDetails(data[widget.ind]["id"])),
                    );
            },
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
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
                        placeholder: 'assets/images/backdrop.jpg',
                        image: data[widget.ind]["backdrop_path"] == null
                            ? ("assets/images/backdrop.jpg")
                            : (image1 + data[widget.ind]["backdrop_path"]),
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
                        widget.type == "tv"
                            ? data[widget.ind]["name"]
                            : data[widget.ind]["title"],
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        widget.type == "tv"
                            ? (data[widget.ind]["first_air_date"] == ""
                                ? 'N/A'
                                : data[widget.ind]["first_air_date"]
                                    .toString()
                                    .substring(0, 4))
                            : (data[widget.ind]["release_date"] == ""
                                ? 'N/A'
                                : data[widget.ind]["release_date"]
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
        } else {
          return Container(
            height: 250,
            width: 250,
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

  @override
  void initState() {
    super.initState();
    this.getdata();
  }
}
