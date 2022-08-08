import 'package:anitierlist/models/character/character_model.dart';
import 'package:anitierlist/models/collection/collection_model.dart';
import 'package:anitierlist/query/query.dart';
import 'package:anitierlist/screens/preview_save_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../models/character/character.dart';


class AddCollection extends StatefulWidget {
  const AddCollection({Key? key}) : super(key: key);

  @override
  AddCollectionState createState() => AddCollectionState();
}

class AddCollectionState extends State<AddCollection>{
  final TextEditingController _collectionTextEditingController = TextEditingController();
  final TextEditingController _searchNameTextEditingController = TextEditingController();
  final TextEditingController _searchShowTextEditingController = TextEditingController();
  CharacterController characterModel = Get.put(CharacterController());
  CollectionController collectionController = Get.put(CollectionController());


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("Add Collection"),
          elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children:  [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
                controller: _collectionTextEditingController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Name this collection',
                )
            ),
          ),
          TextFormField(
            controller: _searchNameTextEditingController,
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              isDense: true,
              labelText: 'Search Characters',
            ),
            onFieldSubmitted: (value) {
              search();
            }
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              controller: _searchShowTextEditingController,
              decoration: const InputDecoration(
                icon: Icon(Icons.filter_alt_rounded),
                isDense: true,
                labelText: 'From Show...',
              ),
              onFieldSubmitted: (value) {
                search();
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(()=>
                  (characterModel.displayList.isEmpty)?
                    const Text("Can't really find anything"):
                    ListView.builder(
                      itemCount: characterModel.displayList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Image.network(
                                    characterModel.displayList[index].imageURL,
                                      fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(characterModel.displayList[index].name,style: TextStyle(fontSize: 14, fontWeight:  FontWeight.bold),),
                                    const SizedBox(height: 5,),
                                    Text(characterModel.displayList[index].titleEN,style: TextStyle(fontSize: 12)),
                                    Text(characterModel.displayList[index].titleROM,style: TextStyle(fontSize: 12))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      style:TextButton.styleFrom(primary: Colors.green),
                                      onPressed: (isAdded(characterModel.displayList[index]))?null:
                                          () {
                                            characterModel.previewList.add(characterModel.displayList[index]);
                                            setState((){});
                                            },
                                      child: const Icon(Icons.add,size: 30,)),
                                    TextButton(
                                      style:TextButton.styleFrom(primary: Colors.red),
                                      onPressed: (!isAdded(characterModel.displayList[index]))?null:
                                          () {
                                            characterModel.previewList.remove(characterModel.displayList[index]);
                                            setState((){});
                                            },
                                      child: const Icon(Icons.remove,size: 30,)),

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );},
                    ),
                  )
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
              onPressed: (){
                collectionController.collectionName.value = _collectionTextEditingController.text;
                Get.to(()=>const PreviewCollection());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.remove_red_eye, color: Colors.white,),
                  ),
                  Text("Preview Collection",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              ))

      )
      ,
    );
  }

  void search(){
    if (_searchNameTextEditingController.text != "" && _searchShowTextEditingController.text!="") {
      characterModel.filterSearch(
          _searchNameTextEditingController.text, _searchShowTextEditingController.text);
    } else if (_searchNameTextEditingController.text != ""){
      characterModel.searchChar(_searchNameTextEditingController.text);
    }
    else if (_searchShowTextEditingController.text != ""){
      characterModel.searchAllCharsFromShow(_searchShowTextEditingController.text);
    }
  }

  bool isAdded(Character character){
    for (Character c in characterModel.previewList){
      if (c.id==character.id){
        return true;
      }
    }
    return false;
  }
}