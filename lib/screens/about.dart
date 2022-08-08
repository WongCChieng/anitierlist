import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("AniTierList", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Text("Developed by JP0", style: TextStyle(fontSize: 18),),
            Text("Powered by AniList API v2", style: TextStyle(fontSize: 18)),
        ],)
      ),
    );
  }
}