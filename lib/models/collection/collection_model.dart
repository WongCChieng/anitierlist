import 'dart:convert';

import 'package:anitierlist/db/collection_db.dart';
import 'package:anitierlist/models/character/character.dart';
import 'package:anitierlist/models/collection/collection.dart';
import 'package:get/get.dart';

import '../../query/query.dart';


class CollectionController extends GetxController{
  CollectionDB collectionDB = CollectionDB();
  var activeCollection = Collection(collectionName: "", characters: [], charactersListString: "").obs;
  var collectionName = ''.obs;
  var collections = <Collection>[].obs;
  var characterList = <Character>[].obs;
  var isEmptied=false.obs;

  @override
  void onInit() {
    isEmptied.value = false;
    super.onInit();
  }

  void getCollections() async{
    var items = await collectionDB.getCollections();
    collections.value = items;
  }

  Future<List<Character>> idsToChars(String listOfID) async{
    List<Character> chars = [];
    var ids = jsonDecode(listOfID);
    for (int id in ids){
      chars.add(await QueryClass().searchCharacterByID(id));
    }
    return chars;
  }

  Future<List<Character>> getChars() async{
    if(characterList.isEmpty && !isEmptied.value){
      characterList.value = await idsToChars(activeCollection.value.charactersListString);
      return characterList;
    }
    else{
      return characterList;
    }
  }


}