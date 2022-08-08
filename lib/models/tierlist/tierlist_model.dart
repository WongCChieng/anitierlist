import 'dart:convert';

import 'package:anitierlist/db/tierlist_db.dart';
import 'package:anitierlist/models/tierlist/tierlist.dart';
import 'package:anitierlist/screens/tier_list.dart';
import 'package:get/get.dart';

import '../../query/query.dart';
import '../character/character.dart';

class TierListController extends GetxController{
  var tlList = <TierList>[].obs;
  var activeTierList = TierList(listName: "", detailMap: "", rows: [
    TLRow("S", []),
    TLRow("A", []),
    TLRow("B", []),
    TLRow("C", []),], unusedCharacters: '', collectionId: null,
    
  ).obs;
  var characterList = <Character>[].obs;
  var isEmptied=false.obs;

  @override
  void onInit() {
    getTLs();
    super.onInit();
  }

  void getTLs() async{
    tlList.value  = await TierListDB().getTLs();
  }

  String toListofStringID(List<Character> chars){
    List<String> s = [];
    for (Character c in chars){
      s.add(c.id.toString());
    }
    return s.toString();
  }

  Map<String,dynamic> listToJson(List<TLRow> rows){
    final Map<String, dynamic> data = <String, dynamic>{};
    for(TLRow row in rows){
      data[row.label] = toListofStringID(row.items);
    }
    return data;
  }

}