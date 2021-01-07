import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/components/PersonDetail.dart';


class MovieCast extends StatefulWidget {
  final int ind;
  final int movid;
  final int cat;
  MovieCast(this.ind, this.movid , this.cat);
  @override
  _MovieCastState createState() => _MovieCastState();
}

class _MovieCastState extends State<MovieCast> {
  List data;
  Future<List> getdata() async {
    if(widget.cat ==0 ){
      var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movid}/credits?api_key=54a91f8f6f10791019cbee06394e04a8'),
    );
    var resBody = json.decode(res.body);
    return data = resBody["cast"];
    }
    else{
      var res = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/tv/${widget.movid}/credits?api_key=54a91f8f6f10791019cbee06394e04a8'),
    );
    var resBody = json.decode(res.body);
    return data = resBody["cast"];
    }

    
  }

  String image = 'http://image.tmdb.org/t/p/w185';

  double width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return FutureBuilder<List>(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonDetail(data[widget.ind]["id"]),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: 'assets/images/9gu9.gif',
                          image: data[widget.ind]["profile_path"] == null
                              ? 'assets/images/9gu9.gif'
                              : image + data[widget.ind]["profile_path"]),
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.0)),
                  ),
                  Text(
                    data[widget.ind]["name"],
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'as',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(data[widget.ind]["character"],
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF035AA6))),
                ],
              ),
            ),
          );
        } else {
          return SizedBox(
            height: 200,
            width: 200,
            child: Center(
              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),),
            ),
          );
        }
      },
    );
  }
}
