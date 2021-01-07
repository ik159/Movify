import 'package:flutter/material.dart';
import 'package:movie/components/MovieHorizontal.dart';
import 'package:movie/components/MovieVerical.dart';


class TVShowsTab extends StatefulWidget {
  @override
  _TVShowsTabState createState() => _TVShowsTabState();
}

class _TVShowsTabState extends State<TVShowsTab> {
  double height, width;

  int horror = 27;
  int action = 28;
  int adventure = 12;
  int animation = 16;
  int comedy = 35;
  int crime = 80;
  int documentary = 99;
  int drama = 18;
  int family = 10751;
  int fantasy = 14;
  int history = 36;
  int music = 10402;
  int mystery = 9648;
  int romance = 10749;
  int scienceFiction = 878;
  int tvMovie = 10770;
  int thriller = 53;
  int war = 10752;
  int western = 37;
  int nowPlaying = 000;
  int tvpop = 111113;
  int tvtoprated = 111112;
  int test = 999;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
            SizedBox(height: 10,),
            headings("Popular" , Color(0xFFFB7BA2), Color(0xFFFCE043)),
            new Container(
              height: height * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) =>
                    MovieHorizotal(ind: index, genre: this.tvpop, type :"tv"),
              ),
            ),
            headings("Top rated" , Color(0xFF000000), Color(0xFFE52222)),
            new Container(
              height: height * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) =>
                    MovieVertical(ind: index, genre: this.tvtoprated , type :"tv"),
              ),
            ),
            headings("Romantic" , Color(0xFFf64f59) , Color(0xFF12c2e9)),
            new Container(
              height: height * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) =>
                    MovieVertical(ind: index, genre: this.romance, type :"tv"),
              ),
            ),
            headings("Comedy" , Color(0xFFCAC531), Color(0xFFF3F9A7)),
            new Container(
              height: height * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) =>
                    MovieHorizotal(ind: index, genre: this.comedy, type :"tv"),
              ),
            ),
            headings("Horror" , Color(0xFF6D6027), Color(0xFFD3CBB8)),
            new Container(
              height: height * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) =>
                    MovieVertical(ind: index, genre: this.horror, type :"tv"),
              ),
            ),
            
            headings("History" , Color(0xFF003B64), Color(0xFFFFF200)),
            new Container(
              height: height * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) =>
                    MovieHorizotal(ind: index, genre: this.history, type :"tv"
              ),
            )),
            headings("Family" , Color(0xFF09C6F9), Color(0xFF045DE9)),
            new Container(
              height: height * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) =>
                    MovieVertical(ind: index, genre: this.family, type :"tv"),
              ),
            ),
            headings("Science Fiction" , Color(0xFFFC575E), Color(0xFF90D5EC)),
            new Container(
              height: height * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) =>
                    MovieHorizotal(ind: index, genre: this.scienceFiction, type :"tv"),
              ),
            ),
            SizedBox(
              height: 20,
            ) //last
          ],
        ),
      )),
    );
  }

  Container headings(String str , Color x1 , Color x2) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            child: Text(str , style: TextStyle(fontWeight: FontWeight.bold),),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [x1, x2]),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
