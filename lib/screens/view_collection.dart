import 'package:anitierlist/db/collection_db.dart';
import 'package:anitierlist/models/character/character.dart';
import 'package:anitierlist/models/collection/collection.dart';
import 'package:anitierlist/models/collection/collection_model.dart';
import 'package:anitierlist/screens/add_collection.dart';
import 'package:anitierlist/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'collection_list.dart';
import 'edit_collection.dart';


class ViewCollection extends StatefulWidget {
  const ViewCollection({Key? key}) : super(key: key);


  @override
  ViewCollectionState createState() => ViewCollectionState();
}

class ViewCollectionState extends State<ViewCollection>{
  List<Character> current=[];
  bool disabled = true;

  Future<List<Character>> _getChars(CollectionController collectionController) async{
    current = await collectionController.idsToChars(collectionController.activeCollection.value.charactersListString);
    return current;
  }

  @override
  Widget build(BuildContext context) {
    CollectionController collectionController = Get.put(CollectionController());
    CollectionDB collectionDB = CollectionDB();

    return WillPopScope(
      onWillPop: () async {
        Get.off(()=>CollectionList());
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading:false,
            title: const Text("View Collection"),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Padding(
                    padding: const EdgeInsets.only(bottom: 10,left: 10,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(collectionController.activeCollection.value.collectionName, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                        TextButton.icon(
                            style: ButtonStyle(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: MaterialStateProperty.all(Colors.red)
                            ),
                            onPressed: (){
                              showDialog(context: context, builder:
                                (context){
                                  return AlertDialog(
                                    title: Text("Are you sure to delete this collection?"),
                                    actions: [
                                      TextButton(onPressed: () async{
                                        await collectionDB.deleteCollection(collectionController.activeCollection.value.collectionId!);
                                        Get.off(()=>CollectionList());
                                      }, child: Text("Yes")),
                                      TextButton(onPressed: ()=>Get.back(), child: Text("No")),
                                    ],
                                  );
                                });
                            },
                            label: const Text("Delete Collection"),
                            icon: const Icon(Icons.delete),)
                      ],
                    )
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Obx(()=>
                            FutureBuilder(
                              future: _getChars(collectionController),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                else if (snapshot.hasData){
                                  disabled = false;
                                  return ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
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
                                                  child: Image.network(snapshot.data[index].imageURL
                                                    ,fit: BoxFit.fitWidth,),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(snapshot.data[index].name,style: TextStyle(fontSize: 14, fontWeight:  FontWeight.bold),),
                                                      const SizedBox(height: 5,),
                                                      Text(snapshot.data[index].titleEN,style: TextStyle(fontSize: 12)),
                                                      Text(snapshot.data[index].titleROM,style: TextStyle(fontSize: 12))
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                                return Center(child: CircularProgressIndicator());

                              }

                            ),
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
                    if(!disabled){
                      collectionController.activeCollection.value = Collection(
                          collectionId: collectionController
                              .activeCollection.value.collectionId,
                          collectionName: collectionController
                              .activeCollection.value.collectionName,
                          characters: current,
                          charactersListString: collectionController
                              .activeCollection.value.charactersListString);
                      Get.to(() => EditCollection());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.edit, color: Colors.white,),
                      ),
                      Text("Edit Collection",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ],
                  ))

          )
      ),
    );
    
  }

}