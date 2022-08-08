import 'dart:convert';

import 'package:anitierlist/db/collection_db.dart';
import 'package:anitierlist/models/collection/collection_model.dart';
import 'package:anitierlist/screens/home_page.dart';
import 'package:anitierlist/screens/view_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CollectionList extends StatelessWidget{

  const CollectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CollectionController collectionController = Get.put(CollectionController());
    collectionController.getCollections();

    return WillPopScope(
      onWillPop: () async{
        Get.off(()=>HomePage());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:false,
          title: const Text("Collections"),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Obx(()=>ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                              itemCount: collectionController.collections.length,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    collectionController.activeCollection.value = collectionController.collections[index];
                                    Get.to(()=>ViewCollection());
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(collectionController.collections[index].collectionName,style: TextStyle(fontSize: 16),),
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        )
        ,
      ),
    );
  }

}