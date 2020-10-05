import 'dart:io';

class AdMobService{
  String getAdMobAppId(){
    if(Platform.isAndroid){
      return 'ca-app-pub-3133774660622345~9265369595';
    }
    return null;
  }

    String getBannerAdId(){
    if(Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/6300978111';  //test ad id 3940256099942544/6300978111
    }  //ca-app-pub-3133774660622345/8690654526
    return null;
  }







}