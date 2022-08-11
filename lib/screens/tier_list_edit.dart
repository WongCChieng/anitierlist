import 'dart:async';
import 'dart:convert';

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

import '../db/collection_db.dart';

class TierListEditScreen extends StatefulWidget{
  const TierListEditScreen({Key? key}) : super(key: key);

  @override
  TierListEditScreenState createState() => TierListEditScreenState();

}

class TierListEditScreenState extends State<TierListEditScreen>{
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    TierListController tierListController = Get.put(TierListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Tier List"),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(tierListController.activeTierList.value.listName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
              FutureBuilder(
                future: tierListController.getTierList(tierListController.activeTierList.value),
                builder: (BuildContext context, AsyncSnapshot<TierList> snapshot) {
                  if(snapshot.hasData){
                    print(snapshot.connectionState);
                    print("snapshot.data!.rows");
                    print(snapshot.data!.rows);
                      return Column(
                        children: [
                          ListView.separated(
                            itemCount: snapshot.data!.rows.length!,
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
                                                  snapshot.data!.rows[index].label = newValue!;
                                                  setState((){});
                                                  Get.back();
                                                },
                                              maxLength: 10,
                                                initialValue: snapshot.data!.rows[index].label,
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      width:screenSize.width*0.2,
                                        child: Center(
                                          child: Text(snapshot.data!.rows[index].label,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),)
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
                                          final element = snapshot.data!.rows[index].items.removeAt(oldIndex);
                                          tierListController.activeTierList.value.rows[index].items.insert(newIndex, element);
                                        });
                                      },
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 70),
                                      itemCount:snapshot.data!.rows[index].items.length,
                                      itemBuilder: (BuildContext context, int index2) {
                                        // return tile(tierListController.activeTierList.value.rows[index].items[index2],index,index2);
                                        return Column();
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
                                                        // collectionController.characterList.addAll(tierListController.activeTierList.value.rows[index].items);
                                                        // tierListController.activeTierList.value.rows.removeAt(index);
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
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator(),);
              })
          ],
        ),
      ),
    );

  }
    
  void itemAction(int item){}

}





















