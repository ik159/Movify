import 'package:flutter/material.dart';
import 'package:movie/components/DevDetails.dart';
import 'package:movie/components/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Theme(
          data: Theme.of(context).copyWith(
                 canvasColor: Colors.black, 
              ),
                  child: Drawer(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(Icons.home , color: Colors.red ),
                    title: Text('Home', style: TextStyle(color: Colors.grey[200])),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UIPage()),
                      );
                    },
                  ),
                  
                  Divider(color: Colors.red,),
                  ListTile(
                    leading: Icon(Icons.star , color: Colors.red  ,),
                    title: Text('Rate this App' , style: TextStyle(color: Colors.grey[200]),),
                    onTap: ()async { //https://play.google.com/store/apps/details?id=com.onefivedev.movie
                      
                  if (await canLaunch("https://play.google.com/store/apps/details?id=com.onefivedev.movie")) {
                      await launch("https://play.google.com/store/apps/details?id=com.onefivedev.movie");
                    }
                    }
                    
                  ),
                  Divider(color: Colors.red,),
                  ListTile(
                    leading: Icon(Icons.computer , color: Colors.red  ,),
                    title: Text('Developer' , style: TextStyle(color: Colors.grey[200]),),
                    onTap: () {
                       showDialog(
                context: context,
                builder: (context) => DevDetails(),
              );
                    },
                  ),
                  Divider(color: Colors.red,),
                  ListTile(
                    leading: Icon(Icons.info , color: Colors.red  ,),
                    title: Text('About' , style: TextStyle(color: Colors.grey[200]),),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutApp()),
                      );
                    },
                  ),
                ],
              ),
            ),
        ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
          elevation: 0,
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "Movify",
            style: TextStyle(color: Colors.red),
          ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "This app uses The Movie Database services but it is not endorsed or certified by it.",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 180,
                  padding: EdgeInsets.all(15),
                  child: Image.asset(
                    'assets/images/tmdb.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "The Movie Database (TMDb) is a community built movie and TV database.Every piece of data has been added by the amazing community dating back to 2008.For more information follow the link below :",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch("https://www.themoviedb.org/")) {
                      await launch("https://www.themoviedb.org/");
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: Text(
                      "https://www.themoviedb.org/",
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontFamily: 'OpenSans',
                          fontSize: 15,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
