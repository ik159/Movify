import 'dart:async';
//import 'dart:html';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import './data_map.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String CATEGORY = 'category';
  static const String MOVIEID = 'movieid';
  static const String TABLE = 'Favs';
  static const String DB_NAME = 'favs.db';

  Future<Database> get db async {
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }
   
   initDb() async {
     io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
     String path = join(documentsDirectory.path , DB_NAME);
     var db = await openDatabase(path , version: 1 , onCreate: _onCreate);
     return db;
   }

   _onCreate(Database db , int version) async {
  // await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $NAME TEXT)");
      await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $CATEGORY INTEGER , $MOVIEID INTEGER)");
   }
  

  Future<Movie> save(Movie movie) async {
    var dbClient = await db;
    movie.id = await dbClient.insert(TABLE, movie.toMap() , conflictAlgorithm: ConflictAlgorithm.replace);
    return movie;
  }
  Future<List<Movie>> getMovies() async {
    print("getting movies");
    var dbClient = await db;
    //List<Map> maps = await dbClient.query(TABLE , columns: [ID , NAME]);
     List<Map> maps = await dbClient.query(TABLE , columns: [ID , CATEGORY , MOVIEID]);
     List<Movie> movies = [];
     if(maps.length > 0){
       for(int i=0; i<maps.length ; i++){
         movies.add(Movie.fromMap(maps[i]));
       }
     }
     print(" in getMovies");
     print(movies);
     return movies;
  }

  Future<int> checkMovie(int category , int movieid) async {
    
    var dbClient = await db;
    //List<Map> maps = await dbClient.query(TABLE , columns: [ID , NAME]);
     List<Map> maps = await dbClient.query(TABLE , columns: [ID , CATEGORY , MOVIEID] , where: '$CATEGORY = ? and $MOVIEID = ?' , whereArgs: [category , movieid]);
     int present = 0;
     if(maps.length > 0){
       present = 1;
     }
     print(" in checkMovie");
     print(present);
     return present;
  }

  Future<int> delete ( int category , int movieid) async {
    var dbClient = await db;
   // return await dbClient.delete(TABLE , where: '$ID = ?' , whereArgs: [id]);
     return await dbClient.delete(TABLE , where: '$CATEGORY = ? and $MOVIEID = ?' , whereArgs: [category , movieid]);
  }

 /* Future<int> update (Movie movie) async {
    print("update in progress");
    print(movie.id);
    print(movie.name);
    var dbClient = await db;
    return await dbClient.insert(TABLE , movie.toMap() , conflictAlgorithm: ConflictAlgorithm.replace,);
    // return await dbClient.delete(TABLE , where: '$MOVIEID = ?' , whereArgs: [movieid]);
  }*/

  Future close () async {
      var dbClient = await db;
      dbClient.close();
  }

}