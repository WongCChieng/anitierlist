import 'package:anitierlist/models/character/character.dart';
import 'package:anitierlist/query/query.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class CharacterController extends GetxController{
  var displayList = <Character>[].obs;
  var previewList = <Character>[].obs;
  QueryClass queryClass = QueryClass();

  @override
  void onInit() {
    super.onInit();
  }

  void searchChar(String charName) async{
    var c = await queryClass.searchCharacterByName(charName);
    displayList.clear();
    if (c.name!=""){
      displayList.add(c);
    }
  }

  void searchAllCharsFromShow(String show) async{
    var main = await queryClass.searchMainCharacterByShow(show);
    var side = await queryClass.searchSideCharacterByShow(show);
    List<Character> c = [];
    c.addAll(main);
    c.addAll(side);
    displayList.value = c;
  }

  void filterSearch(String name, String show) async{
    var main = await queryClass.searchMainCharacterByShow(show);
    var side = await queryClass.searchSideCharacterByShow(show);
    List<Character> c = [];
    c.addAll(main);
    c.addAll(side);

    displayList.clear();

    for (Character character in c){
      if (character.name.toLowerCase().contains(name.toLowerCase())){
        displayList.add(character);
        break;
      }
    }
  }

  Future<Character> searchCharacterByID(int id) async{
    return await queryClass.searchCharacterByID(id);
  }
}