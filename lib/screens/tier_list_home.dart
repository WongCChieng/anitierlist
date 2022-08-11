import 'package:anitierlist/models/tierlist/tierlist_model.dart';
import 'package:anitierlist/screens/select_collection.dart';
import 'package:anitierlist/screens/tier_list.dart';
import 'package:anitierlist/screens/tier_list_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../db/collection_db.dart';

class TierListHome extends StatefulWidget {
  @override
  State<TierListHome> createState() => TierListHomeState();
}
class TierListHomeState extends State<TierListHome>{
  @override
  Widget build(BuildContext context) {
    TierListController tierListController = Get.put(TierListController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tier List"),
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
                      Obx(()=>
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tierListController.tlList.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){
                                  tierListController.activeTierList.value = tierListController.tlList[index];
                                  print(tierListController.activeTierList.value.listName);
                                  Get.to(()=>TierListEditScreen());
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(tierListController.tlList[index].listName,style: TextStyle(fontSize: 16),),
                                        TextButton(onPressed: (){
                                          AniTierList().deleteTL(tierListController.tlList[index].tlId!);
                                          tierListController.getTLs();
                                        }, child: Icon(Icons.delete,color: Colors.red,))                                          ],
                                    ),
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
        bottomNavigationBar:
        BottomAppBar(
            child:
            TextButton(
                onPressed: (){
                  Get.to(()=>const SelectCollection());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.add, color: Colors.white,),
                    ),
                    Text("Create New Tier List",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                ))

        )
    );
  }

}