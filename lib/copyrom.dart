import 'package:flutter/material.dart';
import 'package:movie/movie_details.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/testmovie.dart';

class CopyRom extends StatefulWidget {
  final int ind;
  CopyRom(this.ind);
  @override
  _CopyRomState createState() => _CopyRomState();
}

class _CopyRomState extends State<CopyRom> {
  List data;
  Future<List> getdata() async {
    var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/discover/movie?api_key=54a91f8f6f10791019cbee06394e04a8&with_genres=10749&sort_by=vote_count.desc'),
    );

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
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Container(
                  height: 24.0,
                  child: Center(
                    child: Row(children: <Widget>[
                      SizedBox(
                        width: 30,
                      ),
                      Text("Loading Movie Details"),
                      SizedBox(
                        width: 10,
                      ),
                    ]),
                  ),
                ),
              ));
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TestMovie(data[widget.ind]["id"])),
              );
            },
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ),
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.network(
                        image1 + data[widget.ind]["backdrop_path"],
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
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                      ),
                      child: Text(
                        data[widget.ind]["title"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 15,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                      ),
                      child: Text(
                        data[widget.ind]["vote_average"].toString() + "/10",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.white,
                          fontSize: 15,
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
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(22),
                          bottomLeft: Radius.circular(22),
                        ),
                      ),
                      child: Text(
                        data[widget.ind]["release_date"] == ""
                            ? 'N/A'
                            : data[widget.ind]["release_date"]
                                .toString()
                                .substring(0, 4),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.white,
                          fontSize: 15,
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
          return SizedBox(
            height: 250,
            width: 250,
            child: Center(
              child: CircularProgressIndicator(),
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
