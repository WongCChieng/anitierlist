import 'package:anitierlist/screens/add_collection.dart';
import 'package:anitierlist/screens/collection_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Widget drawer(BuildContext context){
  return SafeArea(
    child: Drawer(
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: ListTile(
              onTap: (){
                Navigator.pop(context);
                Get.to(() => const AddCollection());
              },
              title: Row(
                children: const [
                  Padding(padding: EdgeInsets.only(right: 20),child: Icon(Icons.add)),
                  Text("Add New Collection")
                ],),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: ListTile(
              onTap: (){
                Navigator.pop(context);
                Get.to(() => const CollectionList());
              },
              title: Row(
                children: const [
                  Padding(padding: EdgeInsets.only(right: 20),child: Icon(Icons.book_rounded)),
                  Text("My Collections")
                ],),
            ),
          ),


        ],
      ),
    ),
  );
}