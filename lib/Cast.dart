import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieCast extends StatefulWidget {
  final int ind;
  final int movid;
  MovieCast(this.ind, this.movid);
  @override
  _MovieCastState createState() => _MovieCastState();
}

class _MovieCastState extends State<MovieCast> {
  List data;
  Future<List> getdata() async {
    var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movid}/credits?api_key=54a91f8f6f10791019cbee06394e04a8'),
    );

    var resBody = json.decode(res.body);
    return data = resBody["cast"];
  }

  String image = 'http://image.tmdb.org/t/p/w185';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Container(
              width: 170,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 83,
                    child: FadeInImage.assetNetwork(
                      
                        placeholder: 'assets/images/9gu9.gif',
                        image: data[widget.ind]["profile_path"] == null ? 'assets/images/9gu9.gif' : image + data[widget.ind]["profile_path"] ),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        blurRadius: 2.0,
                      )
                    ]),
                  ),
                  Text(data[widget.ind]["name"],
                      style: TextStyle(
                          fontFamily: 'OpenSans', fontWeight: FontWeight.bold)),
                          Text('as'),
                          Text(data[widget.ind]["character"],
                      style: TextStyle(
                          fontFamily: 'OpenSans', fontWeight: FontWeight.bold,color: Color(0xFF035AA6))),
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
}
