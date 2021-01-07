class Movie {
  int id;
  int category;
  int movieid;
  Movie(this.id,this.category , this.movieid);

  Map<String ,  dynamic> toMap(){
  var map = <String , dynamic>{  'category' : category , 'movieid': movieid};
 // var map = <String , dynamic>{ 'id':id , 'name' : name , 'movieid': movieid};
  print("inside to map");
  return map;
  }

  
 Movie.fromMap( Map<String ,  dynamic> map){
   id= map['id'];
   category = map['category'];
   movieid = map['movieid'];
 }



}