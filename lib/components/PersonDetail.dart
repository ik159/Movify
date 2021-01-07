import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/components/ui.dart';
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
class DetailsById {
  String name;
  String photo;
  String biography;
  String bplace;
  String bday;
  String imdbid;
  DetailsById({this.name, this.photo, this.biography, this.bday, this.bplace , this.imdbid});

  factory DetailsById.fromJson(Map<String, dynamic> json) {
    return DetailsById(
        name: json['name'],
        photo: json['profile_path'],
        biography: json['biography'],
        bday: json['birthday'],
        bplace: json['place_of_birth'],
        imdbid: json['imdb_id'],
        );
        
  }
}

class PersonDetail extends StatefulWidget {
  final int id;

  PersonDetail(this.id);
  @override
  _PersonDetailState createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> {
  List persondata;
  Future<DetailsById> getpersondata() async {
    final response = await http.get(
        "https://api.themoviedb.org/3/person/${widget.id}?api_key=54a91f8f6f10791019cbee06394e04a8&language=en-US");
    if (response.statusCode == 200) {
      return DetailsById.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error occured");
    }
  }

  double height, width;
  String image = 'http://image.tmdb.org/t/p/original';
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return FutureBuilder<DetailsById>(
        future: getpersondata(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40,),
                    Container(
                      
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/backdrop.jpg',
                                  image: snapshot.data.photo == null
                                      ? 'assets/images/backdrop.jpg'
                                      : image + snapshot.data.photo,
                                  height: height * 0.25,
                                  width: height * 0.25,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.0)),
                  ),
                    Container(
                      color: Colors.grey[200],
                                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.only(bottomRight: Radius.circular(16)),
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      snapshot.data.name,
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.red),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      snapshot.data.bplace == null  ? "N/A" : snapshot.data.bplace,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      snapshot.data.bday == null ? "N/A" :snapshot.data.bday,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "IMDb",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow[700]),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.open_in_new,
                                          color: Colors.yellow.shade200,
                                        ),
                                        iconSize: 15,
                                        onPressed: (){
                                          launch("https://www.imdb.com/name/" + snapshot.data.imdbid );
                                        },
                                      )
                                    ],
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
                                    child: Text(
                                      "Biography",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    snapshot.data.biography == ""
                                        ? 'No Data Available'
                                        : snapshot.data.biography,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
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
                
        onPressed: (){
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UIPage(),
                ),
              );
        },
        child: Icon(Icons.home , color: Colors.red,),
        backgroundColor: Colors.white,
      ),
            );
          } else {
            return Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Center(
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),),
                ),
              ),
            );
          }
        },
      );
      
    
  }
}
