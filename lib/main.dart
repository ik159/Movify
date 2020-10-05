import 'package:flutter/material.dart';
import 'package:movie/NowPlaying.dart';
import 'package:movie/TopHorrorMovies.dart';
import 'package:movie/TopRatedMovies.dart';
import 'package:movie/TopRomMovies.dart';
import 'package:movie/TopFamMovies.dart';
import 'package:movie/TopSciFiMovies.dart';
import 'package:movie/SearchResults.dart';
import 'package:movie/UpcomingMovies.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:movie/AboutApp.dart';
import 'package:movie/Animated.dart';
import 'package:movie/Crime.dart';
import 'package:movie/Documentary.dart';
import 'package:movie/History.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:movie/AdMobService.dart';
import 'package:movie/copyrom.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF035AA6),
        accentColor: Color(0xFF035AA6),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  bool isPressed = false;
  final ams = AdMobService();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Admob.initialize(ams.getAdMobAppId());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      child: Scaffold(
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
          backgroundColor: Color(0xFF035AA6),
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Movify',
              style: TextStyle(fontSize: 16.0),
            ),
            bottom: PreferredSize(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      child: AdmobBanner(
                        adUnitId: ams.getBannerAdId(),
                        adSize: AdmobBannerSize.FULL_BANNER,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: myController,
                        onSubmitted: (String str) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResults(str)),
                          );
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SearchResults(myController.text)),
                              );
                            },
                          ),
                          hintText: 'Search for  movies...',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Colors.white.withOpacity(0.3),
                        indicatorColor: Colors.white,
                        tabs: [
                          Tab(
                            child: Text('Romance'),
                          ),
                          Tab(
                            child: Text('Sci Fi'),
                          ),
                          Tab(
                            child: Text('Documentary'),
                          ),
                          Tab(
                            child: Text('Animated'),
                          ),
                          Tab(
                            child: Text('Top Rated'),
                          ),
                          Tab(
                            child: Text('Crime'),
                          ),
                          Tab(
                            child: Text('History'),
                          ),
                          Tab(
                            child: Text('Family'),
                          ),
                          Tab(
                            child: Text('Horror'),
                          ),
                          Tab(
                            child: Text('Now Playing(🇺🇸)'),
                          ),
                        ]),
                  ],
                ),
                preferredSize: Size.fromHeight(170.0)),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,  //0xFFF1EFF1
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 20,
                          itemBuilder: (context, index) => CopyRom(index)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1EFF1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 20,
                          itemBuilder: (context, index) =>
                              TopSciFiMovies(index)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1EFF1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 20,
                          itemBuilder: (context, index) => Documentary(index)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1EFF1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 20,
                          itemBuilder: (context, index) => Animated(index)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1EFF1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 20,
                          itemBuilder: (context, index) =>
                              TopRatedMovies(index)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1EFF1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 20,
                          itemBuilder: (context, index) => Crime(index)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1EFF1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 20,
                          itemBuilder: (context, index) => History(index)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1EFF1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 20,
                          itemBuilder: (context, index) => TopFamMovies(index)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1EFF1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 20,
                          itemBuilder: (context, index) =>
                              TopHorrorMovies(index)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1EFF1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 20,
                          itemBuilder: (context, index) => NowPlayingUS(index)),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
