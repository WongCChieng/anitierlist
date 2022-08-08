import 'dart:io';

import 'package:anitierlist/query/query.dart';
import 'package:anitierlist/screens/tier_list_home.dart';
import 'package:anitierlist/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  selectedItem(val, context){
    if (val==0){
      Get.to(()=>AboutPage());
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        exit(0);
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text("AniTierList"),
            elevation: 0,
            actions: [
            Theme(
            data: Theme.of(context).copyWith(
                dividerColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.white)),
            child: PopupMenuButton<int>(
              color: Colors.grey[900],
              itemBuilder: (context) => [
                PopupMenuItem<int>(value: 0, child: const Text("About", style: TextStyle(color: Colors.white),)),
            ],
            onSelected: (item)=>selectedItem(item,context),
            ),
          ),
        ]),
        drawer: drawer(context),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Get.to(()=>TierListHome());
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black12,
                child:  Column(
                  children: const [
                    Expanded(child: Icon(Icons.list)),
                    Text("Tier List",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black12,
              child:  Column(
                children: const [
                  Expanded(child: Icon(Icons.format_list_numbered_outlined)),
                  Text("Ranking",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}


