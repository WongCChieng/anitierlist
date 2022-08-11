import 'package:anitierlist/db/collection_db.dart';
import 'package:anitierlist/models/character/character_model.dart';
import 'package:anitierlist/models/collection/collection_model.dart';
import 'package:anitierlist/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/collection/collection.dart';


class PreviewCollection extends StatefulWidget {
  const PreviewCollection({Key? key}) : super(key: key);

  @override
  PreviewCollectionState createState() => PreviewCollectionState();
}

class PreviewCollectionState extends State<PreviewCollection>{

  @override
  Widget build(BuildContext context) {
    CollectionController collectionController = Get.put(CollectionController());
    CharacterController characterController = Get.put(CharacterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Collection"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(collectionController.collectionName.value, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(()=>ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: characterController.previewList.length,
                        itemBuilder: (context,index){
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    padding: EdgeInsets.only(right: 8),
                                    child: Image.network(characterController.previewList[index].imageURL
                                      ,fit: BoxFit.fitWidth,),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(characterController.previewList[index].name,style: TextStyle(fontSize: 14, fontWeight:  FontWeight.bold),),
                                        const SizedBox(height: 5,),
                                        Text(characterController.previewList[index].titleEN,style: TextStyle(fontSize: 12)),
                                        Text(characterController.previewList[index].titleROM,style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          )
        ],),
      ),

        bottomNavigationBar:
        BottomAppBar(
            child:
            TextButton(
                onPressed: () async{
                  if(collectionController.collectionName.value!=""
                  && characterController.previewList.isNotEmpty)
                  {
                    Collection collection = Collection(
                        collectionName:
                            collectionController.collectionName.value,
                        characters: characterController.previewList,
                        charactersListString: '');
                    AniTierList db = AniTierList();
                    await db.insertCollection(collection);
                    Get.offAll(() => const HomePage());
                  }
                  else{
                    showDialog(context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text("Please add a collection name or make sure the collection is not empty"),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Get.back();
                                  },
                                  child: Text("Cancel"))
                            ],
                          );
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.save, color: Colors.white,),
                    ),
                    Text("Save Collection",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                ))

        )
    );
  }

}