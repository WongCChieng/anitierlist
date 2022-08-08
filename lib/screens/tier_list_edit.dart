import 'dart:async';
import 'dart:convert';

import 'package:anitierlist/db/tierlist_db.dart';
import 'package:anitierlist/models/collection/collection_model.dart';
import 'package:anitierlist/models/tierlist/tierlist_model.dart';
import 'package:anitierlist/models/tierlist/tierlist.dart';
import 'package:anitierlist/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:anitierlist/models/character/character.dart';

class TierListEditScreen extends StatefulWidget{
  const TierListEditScreen({Key? key}) : super(key: key);

  @override
  TierListEditScreenState createState() => TierListEditScreenState();

}

class TierListEditScreenState extends State<TierListEditScreen>{
  CollectionController collectionController = Get.put(CollectionController());
  TierListController tierListController = Get.put(TierListController());
  int selectedItem=0;
  TierList emptyTL = TierList(listName: "", detailMap: "", rows: [
    TLRow("S", []),
    TLRow("A", []),
    TLRow("B", []),
    TLRow("C", []),], unusedCharacters: '', collectionId: null,
  );

  Widget tile(Character character, int rowIndex, int charIndex) {
    return GestureDetector(
      key: ValueKey(character.id),
      onTap: (){
        // collectionController.characterList.add(character);
        // tierListController.activeTierList.value.rows[rowIndex].items.removeAt(charIndex);

      },
      child: Image.network(
          character.imageURL,
          fit: BoxFit.fitWidth),
    );
  }

  @override
  void dispose() {
    // tierListController.activeTierList.value=emptyTL;
    // collectionController.isEmptied.value = false;
    // collectionController.characterList.value = [];

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(tierListController.activeTierList.value.listName);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Tier List"),
        elevation: 0,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item)=>itemAction(item),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 0,
                    child: Text("Refresh List"),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text("Add New Row"),
                  ),

                ];
              },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(()=>Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(tierListController.activeTierList.value.listName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                  ListView.separated(
                    itemCount: tierListController.activeTierList.value.rows.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              showDialog(context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      backgroundColor: Colors.black,
                                      title: TextFormField(
                                        onFieldSubmitted: (newValue){
                                          tierListController.activeTierList.value.rows[index].label = newValue!;
                                          setState((){});
                                          Get.back();
                                        },
                                        maxLength: 10,
                                        initialValue: tierListController.activeTierList.value.rows[index].label,
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              width:screenSize.width*0.2,
                              child: Center(
                                  child: Text(tierListController.activeTierList.value.rows[index].label,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),)
                              ),
                            ),
                          ),
                          Container(
                            width:screenSize.width*0.7,
                            child:
                            ReorderableGridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                onReorder: (oldIndex, newIndex) {
                                  setState(() {
                                    final element = tierListController.activeTierList.value.rows[index].items.removeAt(oldIndex);
                                    tierListController.activeTierList.value.rows[index].items.insert(newIndex, element);
                                  });
                                },
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 70),
                              itemCount:tierListController.activeTierList.value.rows[index].items.length,
                              itemBuilder: (BuildContext context, int index2) {
                                  return tile(tierListController.activeTierList.value.rows[index].items[index2],index,index2);
                              },
                            ),
                          ),
                          Container(
                            width: screenSize.width*0.1,
                            child: Column(
                              children: [
                                TextButton(
                                  style:ButtonStyle(
                                    visualDensity: VisualDensity.compact
                                  ),
                                  onPressed: () {
                                    if(index>0){
                                      TLRow holder = tierListController.activeTierList.value.rows[index];
                                      tierListController.activeTierList.value.rows[index] = tierListController.activeTierList.value.rows[index-1];
                                      tierListController.activeTierList.value.rows[index-1] = holder;
                                      setState((){});
                                    }
                                  },
                                  child: Icon(Icons.expand_less,color: Colors.white,),
                                ),
                                TextButton(
                                  style:ButtonStyle(
                                      visualDensity: VisualDensity.compact
                                  ),
                                  onPressed: () {
                                      showDialog(context: context,
                                          builder: (context){
                                            return AlertDialog(
                                              backgroundColor: Colors.black,
                                              title: Text("Are you sure to delete this row?"),
                                              actions: [
                                                TextButton(onPressed: (){
                                                  collectionController.characterList.addAll(tierListController.activeTierList.value.rows[index].items);
                                                  tierListController.activeTierList.value.rows.removeAt(index);
                                                  Get.back();
                                                  }, child: Text("Yes")),
                                                TextButton(onPressed: (){()=>Get.back();}, child:  Text("No"))
                                              ],
                                            );
                                          });
                                  },
                                  child: Icon(Icons.delete,color: Colors.red,),
                                ),
                                TextButton(
                                  style:ButtonStyle(
                                      visualDensity: VisualDensity.compact
                                  ),
                                  onPressed: () {
                                    if(index<tierListController.activeTierList.value.rows.length){
                                      TLRow holder = tierListController.activeTierList.value.rows[index];
                                      tierListController.activeTierList.value.rows[index] = tierListController.activeTierList.value.rows[index+1];
                                      tierListController.activeTierList.value.rows[index+1] = holder;
                                      setState((){});
                                    }
                                  },
                                  child: Icon(Icons.expand_more,color: Colors.white,),
                                ),

                              ],
                            ),
                          )
                        ],
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                        return Divider(thickness: 2,color: Colors.white,);
                  },
                ),

                SizedBox(height: 10,),
                FutureBuilder(
                future: collectionController.getChars(),
                builder: (BuildContext context, AsyncSnapshot<List<Character>> snapshot) {
                  if (snapshot.hasData){
                    return GridView.builder(
                      shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context,index){
                          return GestureDetector(
                            onLongPress: (){
                              showDialog(context: context,
                                  builder: (context){
                                    return Dialog(
                                      backgroundColor: Colors.black,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: tierListController.activeTierList.value.rows.length,
                                          itemBuilder: (context,sIndex){
                                            return ListTile(
                                              onTap: (){
                                                tierListController.activeTierList.value.rows[sIndex].items.add(snapshot.data?[index]??Character());
                                                collectionController.characterList.removeAt(index);
                                                if (collectionController.characterList.isEmpty){
                                                  collectionController.isEmptied.value = true;
                                                }
                                                Get.back();
                                              },
                                              title: Text(tierListController.activeTierList.value.rows[sIndex].label),
                                            );
                                          }),
                                    );
                                  });

                            },
                            child: Image.network(
                                snapshot.data?[index].imageURL ?? "http://via.placeholder.com/150x150",
                                fit: BoxFit.fitWidth),
                          );
                        });
                  }
                  return Center(child: CircularProgressIndicator());

                },

              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      BottomAppBar(
          child:
          TextButton(
              onPressed: (){
                saveTierList();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.save, color: Colors.white,),
                  ),
                  Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              )
          )

      )
    );

  }

  void saveTierList(){
    showDialog(context: context,
        builder: (context){
          return Dialog(
            child: Container(
              height: 100,
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tier List Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Tier List Name"
                      ),
                      initialValue: tierListController.activeTierList.value.listName,
                      onFieldSubmitted: (value){
                        if (value!="" && tierListController.activeTierList
                            .value.rows.isNotEmpty){
                          if (tierListController.activeTierList.value.tlId==null){
                            TierListDB().insertTL(TierList(
                              listName: value,
                              detailMap: jsonEncode(tierListController.listToJson(tierListController.activeTierList.value.rows)), rows: [],
                              unusedCharacters: tierListController.toListofStringID(collectionController.characterList),
                              collectionId: collectionController.activeCollection.value.collectionId
                            ));
                          }
                          else{
                            TierListDB().updateTL(TierList(
                                tlId: tierListController.activeTierList.value.tlId,
                                listName: value,
                                detailMap: jsonEncode(tierListController.listToJson(tierListController.activeTierList.value.rows)), rows: [],
                                unusedCharacters: tierListController.toListofStringID(collectionController.characterList),
                                collectionId: collectionController.activeCollection.value.collectionId
                            ));
                          }
                          Get.offAll(HomePage());

                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void addNewRow(){
    showDialog(context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Column(
            children: [
              TextFormField(
                onFieldSubmitted: (newValue){
                  if (newValue!=""){
                    tierListController.activeTierList.value.rows.add(TLRow(newValue, []));
                    setState((){});
                    Get.back();
                  }

                },
                decoration: InputDecoration(
                  hintText: "Row Name"
                ),
                maxLength: 10,
              ),
            ],
          ),
        );
      });
  }

  void itemAction(int num){
    switch(num){
      case 0:
        collectionController.isEmptied.value = false;
        collectionController.characterList.clear();
        tierListController.activeTierList.value = emptyTL;
        break;
      case 1:
        addNewRow();
    }
  }

}





















