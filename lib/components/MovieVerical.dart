import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/components/TVDetails.dart';
import 'package:movie/components/details.dart';


class MovieVertical extends StatefulWidget {
  final int ind;
  final int genre;
  final String type;
  MovieVertical({this.ind, this.genre , this.type});
  @override
  _MovieVerticalState createState() => _MovieVerticalState();
}

class _MovieVerticalState extends State<MovieVertical> {
  List data;
  Future<List> getdata() async {

    var res;
    if(widget.type == "movie"){
res = await http.get(
      "https://api.themoviedb.org/3/discover/movie?api_key=54a91f8f6f10791019cbee06394e04a8&with_genres=${widget.genre}&sort_by=vote_count.desc",
    );
    }
    else{
      if(widget.genre == 111112){
res = await http.get(
      "https://api.themoviedb.org/3/tv/top_rated?api_key=54a91f8f6f10791019cbee06394e04a8&language=en-US",
    );
      }
      else{
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
  String image = 'http://image.tmdb.org/t/p/w780';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: (){
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
            /*() {
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
            },*/
            child: Container(
              
              margin: EdgeInsets.symmetric(horizontal: 15 , vertical: 15),
              
              child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                  placeholder: 'assets/images/9gu9.gif',
                  image: image + data[widget.ind]["poster_path"]),
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
          );
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
    );
  }

  @override
  void initState() {
    super.initState();
    this.getdata();
  }
}
