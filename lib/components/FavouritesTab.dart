import 'package:flutter/material.dart';
import 'package:movie/components/TVDetails.dart';
import 'package:movie/components/details.dart';
import './local_db_storage/db_helper.dart';
import './local_db_storage/data_map.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class FavouritesTab extends StatefulWidget {
  @override
  _FavouritesTabState createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<FavouritesTab> {
  Future<List<Movie>> movies;
  var dbHelper;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshList();
  }

  refreshList() {
    setState(() {
      movies = dbHelper.getMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
          child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: movies,
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data.length == 0) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text("Favourites list is empty"));
                }
                if (snapshot.hasData) {
                  // print(movies);
                  print(snapshot.data[0].id);
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListofFavs(snapshot.data[index].category,
                            snapshot.data[index].movieid);
                      });
                }
              },
            ) //last
          ],
        ),
      )),
    );
  }
}

class DetailsInFav {
  String backdropPath;
  int id;
  String title;

  DetailsInFav({
    this.title,
    this.backdropPath,
    this.id,
  });

  factory DetailsInFav.fromJson(Map<String, dynamic> json) {
    return DetailsInFav(
      backdropPath: json['backdrop_path'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class DetailsInFavTV {
  String backdropPath;
  int id;
  String title;

  DetailsInFavTV({
    this.title,
    this.backdropPath,
    this.id,
  });

  factory DetailsInFavTV.fromJson(Map<String, dynamic> json) {
    return DetailsInFavTV(
      backdropPath: json['backdrop_path'],
      id: json['id'],
      title: json['name'],
    );
  }
}

class ListofFavs extends StatefulWidget {
  final int cat;
  final int movid;
  ListofFavs(this.cat, this.movid);
  @override
  _ListofFavsState createState() => _ListofFavsState();
}

class _ListofFavsState extends State<ListofFavs> {
  String image = 'https://image.tmdb.org/t/p/w1280';
  int ctrpass = 0;
  var data;
  Future<DetailsInFav> getData() async {
    
final response = await http.get(
        "https://api.themoviedb.org/3/movie/${widget.movid}?api_key=54a91f8f6f10791019cbee06394e04a8&language=en-US");
    if (response.statusCode == 200) {
      return DetailsInFav.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error occured");
    }

  }

   Future<DetailsInFavTV> getDataTV() async {
    
final response = await http.get(
        "https://api.themoviedb.org/3/tv/${widget.movid}?api_key=54a91f8f6f10791019cbee06394e04a8&language=en-US");
    if (response.statusCode == 200) {
      return DetailsInFavTV.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error occured");
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.cat ==0 ? getData(): getDataTV(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 250,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              widget.cat == 0 ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MovieDetails(widget.movid)),
              ): Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TVShowsDetails(widget.movid)),
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
                        image: snapshot.data.backdropPath == null
                            ? ("assets/images/backdrop.jpg")
                            : (image + snapshot.data.backdropPath),
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
                        snapshot.data.title,
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
        }
      },
    );
  }
}
