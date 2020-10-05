import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/movie_details.dart';

class SimilarMovies extends StatefulWidget {
  final int ind;
  final int movid;
  SimilarMovies(this.ind, this.movid);
  @override
  _SimilarMoviesState createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  List data;
  Future<List> getdata() async {
    var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movid}/similar?api_key=54a91f8f6f10791019cbee06394e04a8&language=en-US&page=1'),
    );

    var resBody = json.decode(res.body);
    return data = resBody["results"];
  }

  String image = 'http://image.tmdb.org/t/p/w185';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MovieDetails(data[widget.ind]["id"])),
              );
            },
            child: Container(
              width: 145,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 188,
                    child: FadeInImage.assetNetwork(placeholder: 'assets/images/9gu9.gif', image: image + data[widget.ind]["poster_path"]),
                    decoration: BoxDecoration(
                      //image: DecorationImage(
                          // image: NetworkImage(
                          //     image + data[widget.ind]["poster_path"]),
                          // fit: BoxFit.contain),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
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
}
