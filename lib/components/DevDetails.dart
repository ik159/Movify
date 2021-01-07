import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DevDetails extends StatelessWidget {
  final Color myColor = Color(0xff00bfa5);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      title: Column(
        children: <Widget>[
          Container(
            child: ClipOval(
              child: Image.asset(
                'assets/images/ik.jpeg',
                height: 125,
                fit: BoxFit.cover,
              ),
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2.0)),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text("Ishan Kumar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                )),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              "Connect : ",
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: ()async{
                  if (await canLaunch("https://www.linkedin.com/in/ik159/")) {
                      await launch("https://www.linkedin.com/in/ik159/");
                    }
                },
                              child: Container(
                  width: 25,
                  child: Image.asset("assets/images/linked.png"),
                ),
              ),
              GestureDetector(
                onTap: ()async{
                  if (await canLaunch("https://github.com/ik159")) {
                      await launch("https://github.com/ik159");
                    }
                },
                              child: Container(
                  width: 25,
                  child: Image.asset("assets/images/git.png"),
                ),
              ),
              GestureDetector(
                onTap: ()async{
                  if (await canLaunch("mailto:onefivedev@gmail.com")) {
                      await launch("mailto:onefivedev@gmail.com");
                    }
                },
                              child: Container(
                  width: 25,
                  child: Image.asset("assets/images/gmail.png"),
                ),
              ),
              GestureDetector(
                onTap: ()async{
                  if (await canLaunch("https://www.instagram.com/ik.159/")) {
                      await launch("https://www.instagram.com/ik.159/");
                    }
                },
                              child: Container(
                  width: 25,
                  child: Image.asset("assets/images/ig.png"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
