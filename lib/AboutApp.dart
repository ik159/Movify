import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movie/main.dart';
class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset('assets/images/tmdb.jpg'),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About App'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutApp()),
                    );
                  },
                ),
                Spacer(flex: 8),
              ],
            ),
          ),
      appBar: AppBar(title: Text("Movify"),
      centerTitle: true,
      elevation: 0,
      ),
      backgroundColor: Color(0xFF035AA6),
      body: SingleChildScrollView(
              child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            height: 600,
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
                    padding: EdgeInsets.only(left: 15,right: 15,top: 5),
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
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Center(child: Text("- App developed by Ishan K."),),)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
        },
        child: Icon(Icons.home),
        backgroundColor: Color(0xFF035AA6),
      ),
    );
  }
}
