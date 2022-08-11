import 'package:anitierlist/db/collection_db.dart';
import 'package:anitierlist/models/character/character_model.dart';
import 'package:anitierlist/models/collection/collection_model.dart';
import 'package:anitierlist/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/character/character.dart';
import '../models/collection/collection.dart';


class PreviewEditCollection extends StatefulWidget {
  const PreviewEditCollection({Key? key}) : super(key: key);


  @override
  PreviewEditCollectionState createState() => PreviewEditCollectionState();
}

class PreviewEditCollectionState extends State<PreviewEditCollection>{

  @override
  Widget build(BuildContext context) {
    CollectionController collectionController = Get.put(CollectionController());

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
                        itemCount: collectionController.activeCollection.value.characters.length,
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
                                    child: Image.network(collectionController.activeCollection.value.characters[index].imageURL
                                      ,fit: BoxFit.fitWidth,),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(collectionController.activeCollection.value.characters[index].name,style: TextStyle(fontSize: 14, fontWeight:  FontWeight.bold),),
                                        const SizedBox(height: 5,),
                                        Text(collectionController.activeCollection.value.characters[index].titleEN,style: TextStyle(fontSize: 12)),
                                        Text(collectionController.activeCollection.value.characters[index].titleROM,style: TextStyle(fontSize: 12))
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
                  && collectionController.activeCollection.value.characters.isNotEmpty)
                  {
                    Collection collection = Collection(
                        collectionId: collectionController
                            .activeCollection.value.collectionId,
                        collectionName:
                            collectionController.collectionName.value,
                        characters: collectionController.activeCollection.value.characters,
                        charactersListString: toListString(collectionController.activeCollection.value.characters));
                    AniTierList db = AniTierList();
                    await db.updateCollection(collection);
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

  String toListString(List<Character> chars){
    List<String> result = [];
    for (Character c in chars){
      result.add(c.id.toString());
    }
    return result.toString();
  }

}