import 'package:anitierlist/models/collection/collection_model.dart';
import 'package:anitierlist/screens/add_collection.dart';
import 'package:anitierlist/screens/tier_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SelectCollection extends StatelessWidget{
  const SelectCollection({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    CollectionController collectionController = Get.put(CollectionController());
    collectionController.getCollections();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New List"),
        elevation: 0,
      ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Select a Collection",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            TextButton.icon(
                                onPressed: (){
                                  Get.to(()=>AddCollection());
                                },
                                icon: Icon(Icons.add),
                                label: Text("Add New Collection"))
                        ],),
                        Obx(()=>
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: collectionController.collections.length,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    collectionController.activeCollection.value=collectionController.collections[index];
                                    Get.to(()=>TierListScreen());},
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
        ),

    );
  }

}