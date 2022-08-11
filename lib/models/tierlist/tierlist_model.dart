import 'dart:convert';

import 'package:anitierlist/models/tierlist/tierlist.dart';
import 'package:anitierlist/screens/tier_list.dart';
import 'package:get/get.dart';

import '../../db/collection_db.dart';
import '../../query/query.dart';
import '../character/character.dart';

class TierListController extends GetxController{
  var tlList = <TierList>[].obs;
  var activeTierList = TierList(listName: "", detailMap: "", rows: [
    TLRow(0,"S", []),
    TLRow(1,"A", []),
    TLRow(2,"B", []),
    TLRow(3,"C", []),], unusedCharacters: '', collectionId: null, unused: []
  ).obs;
  var characterList = <Character>[].obs;
  var isEmptied=false.obs;
  var rows = <TLRow>[].obs;

  @override
  void onInit() {
    getTLs();
    super.onInit();
  }

  void getTLs() async{
    tlList.value  = await AniTierList().getTLs();
  }

  String toListofStringID(List<Character> chars){
    List<String> s = [];
    for (Character c in chars){
      s.add(c.id.toString());
    }
    return s.toString();
  }

  Future<TierList> getTierList(TierList tierList) async{
    TierList tl = TierList(
        rows: [],
        unused:[],
        listName: tierList.listName,
        detailMap: tierList.detailMap,
        collectionId: tierList.collectionId,
        unusedCharacters: tierList.unusedCharacters,
    );

    await processDetailMap(tierList).then((value) async{
      tl.rows = value;
      await idsToChars(tierList.unusedCharacters).then((value) {
        tl.unused = value;
        print("loaded");
        return tl;
      });
    });
    return tl;
  }
  
  Future<List<TLRow>> processDetailMap(TierList tierList) async{
    var listOfRows = jsonDecode(tierList.detailMap);
    List<TLRow> rows = List.generate(listOfRows.length, (index) => TLRow(0, "", []));
    await listOfRows.forEach(
      (json) async{
        rows[json["index"]] = TLRow(json["index"], json["label"], await idsToChars(json["charList"]));
      }
    );
    return rows;
  }

  Future<List<Character>> idsToChars(String listOfID) async{
    List<Character> chars = [];
    var ids = jsonDecode(listOfID);
    for (int id in ids){
      QueryClass().searchCharacterByID(id).then(
              (value) => chars.add(value));
    }
    return chars;
  }

  List<Map<String,dynamic>> listToJson(List<TLRow> rows){
    final List<Map<String,dynamic>> data = [];
    for(int i=0;i<rows.length;i++){
      data.add({
        "index":i,
        "label":rows[i].label,
        "charList": toListofStringID(rows[i].items)
      });
    }
    return data;
  }

}