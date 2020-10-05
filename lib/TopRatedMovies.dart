import 'package:flutter/material.dart';
import 'package:movie/movie_details.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
class TopRatedMovies extends StatefulWidget {
  final int ind;
   TopRatedMovies (this.ind);
  @override
  _TopRatedMoviesState createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {

  List data;
   Future<List> getdata() async {
    var res =
        await http.get(Uri.parse('https://api.themoviedb.org/3/movie/top_rated?api_key=54a91f8f6f10791019cbee06394e04a8'), );

    
      var resBody = json.decode(res.body);
     return data = resBody["results"];
    

    
  }

 
 String image='http://image.tmdb.org/t/p/w185';
   bool onlisttap = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: getdata(),
      builder: (context,snapshot){
        if(snapshot.hasData){
    return GestureDetector(
      onTap: (){
        Scaffold.of(context).showSnackBar(SnackBar(
                content: Container(
                  height: 24.0,
                  child: Center(
                    child: Row(children: <Widget>[
                      SizedBox(width: 30,),
                      Text("Loading Movie Details"),
                      SizedBox(width: 10,),
                      
                    ]),
                  ),
                ),
              ));
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MovieDetails(data[widget.ind]["id"])),
  );
      },
    child: InkWell(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            height: 136,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.red,
            ),
            child: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color:(onlisttap)? Colors.grey : Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 121.0, left: 15.0),
              width: 80.0,
              height: 30.0,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: Center(
                child: Text(
                  data[widget.ind]["vote_average"].toString() 
                  + "/10",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          Container(
              margin: EdgeInsets.only(right: 25.0, left: 15.0, top: 15.0),
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
                  data[widget.ind]["title"],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    
                  ),
                ),
              )),
              
              
          Positioned(
            height: 106,
            top: 45.0,
            right: 25.0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(22),
              ),
              child: Image.network(image+data[widget.ind]["poster_path"]),
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
                  data[widget.ind]["release_date"] == ""
                                              ? 'N/A'
                                              : data[widget.ind]["release_date"]
                                                  .toString()
                                                  .substring(0, 4),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
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
                      text: 
                  data[widget.ind]["overview"] ==
                                                      ""
                                                  ? 'Data Not Available'
                                                  : (data[widget.ind]["overview"]
                                                              .toString()
                                                              .length <=
                                                          40
                                                      ? data[widget.ind]["overview"]
                                                          .toString()
                                                      : data[widget.ind]["overview"]
                                                          .toString()
                                                          .substring(0, 40)),
                  style: TextStyle(
                    color: Color(0xFF035AA6).withOpacity(0.7),
                  
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                children: <TextSpan>[
                  TextSpan(text: ('    ')),
                  TextSpan(text: '..read more',
                  style: TextStyle(color: Colors.black,decoration: TextDecoration.underline,fontSize: 10.0),
                  ),
                ]
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );

        }
        else{
          return SizedBox(height: 250,width: 250,child: Center(child: CircularProgressIndicator(),),);
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
