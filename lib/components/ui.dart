import 'package:flutter/material.dart';
import 'package:movie/components/AboutApp.dart';
import 'package:movie/components/DevDetails.dart';
import 'package:movie/components/FavouritesTab.dart';
import 'package:movie/components/MoviesTab.dart';
import 'package:movie/components/SearchResults.dart';
import 'package:movie/components/TvShowsTab.dart';
import 'package:url_launcher/url_launcher.dart';

class UIPage extends StatefulWidget {
  @override
  _UIPageState createState() => _UIPageState();
}

class _UIPageState extends State<UIPage> {
  double width, height;

  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                  leading: Icon(Icons.home, color: Colors.red),
                  title:
                      Text('Home', style: TextStyle(color: Colors.grey[200])),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UIPage()),
                    );
                  },
                ),
                Divider(
                  color: Colors.red,
                ),
                ListTile(
                  leading: Icon(
                    Icons.star,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Rate this App',
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                  
                    onTap: ()async { //https://play.google.com/store/apps/details?id=com.onefivedev.movie
                      
                  if (await canLaunch("https://play.google.com/store/apps/details?id=com.onefivedev.movie")) {
                      await launch("https://play.google.com/store/apps/details?id=com.onefivedev.movie");
                    }
                    },
                 
                ),
                Divider(
                  color: Colors.red,
                ),
                ListTile(
                  leading: Icon(
                    Icons.computer,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Developer',
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => DevDetails(),
                    );
                  },
                ),
                Divider(
                  color: Colors.red,
                ),
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.red,
                  ),
                  title: Text(
                    'About',
                    style: TextStyle(color: Colors.grey[200]),
                  ),
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
          bottom: PreferredSize(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
               
                controller: myController,
                
                onFieldSubmitted: (String str) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchResults(str)),
                  );
                  myController.clear();
                },
                style: TextStyle(color: Colors.white),
                
                decoration: InputDecoration(
                  
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.15),
                  enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchResults(myController.text)),
                  );
                  myController.clear();
                },
                  ),
                  hintText: 'Movies, TV Shows and more...',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(70),
          ),
        ),
        body: TabBarView(
          children: [
            MoviesTab(),
            TVShowsTab(),
            FavouritesTab(),
          ],
        ),
        backgroundColor: Colors.black,
        bottomNavigationBar: Container(
          height: 48,
          child: TabBar(
            tabs: [
              Tab(
                icon: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: <Color>[
                        Colors.greenAccent[200],
                        Colors.blueAccent[200]
                      ],
                    ).createShader(bounds);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Column(
                      children: [
                        Icon(Icons.local_movies),
                        Text(
                          "Movies",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Tab(
                icon: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: <Color>[
                        Colors.greenAccent[200],
                        Colors.blueAccent[200]
                      ],
                    ).createShader(bounds);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.live_tv),
                        Text(
                          "TV Shows",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Tab(
                icon: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: <Color>[
                        Colors.greenAccent[200],
                        Colors.blueAccent[200]
                      ],
                    ).createShader(bounds);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Column(
                      children: [
                        Icon(Icons.favorite),
                        Text(
                          "Favs",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
          ),
        ),
      ),
    );
  }
}
