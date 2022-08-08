import 'dart:convert';

import 'package:anitierlist/models/character/character.dart';

class TierList{
  int? tlId;
  String listName='';
  String detailMap='';
  List<TLRow> rows=[
    TLRow("S", []),
    TLRow("A", []),
    TLRow("B", []),
    TLRow("C", []),];
  int? collectionId;
  String? unusedCharacters;

  TierList({
    this.tlId,
    required this.listName,
    required this.detailMap,
    required this.rows,
    required this.collectionId,
    required this.unusedCharacters
  });

  void mapJsonToRows(Map<String,dynamic> json){
    json.forEach((key, value) {
      rows.add(TLRow(key,jsonDecode(value)));
    });
  }


  Map<String, dynamic> toMap(){
    return {
      "tlId":tlId,
      "listName":listName,
      "detailMap":detailMap,
      "collectionId":collectionId,
      "unusedCharacters":unusedCharacters
    };
  }

  TierList.fromMap(Map<String, dynamic> data){
    tlId = data["tlId"];
    listName = data["listName"];
    detailMap = data["detailMap"];
    collectionId = data["collectionId"];
    unusedCharacters = data["unusedCharacters"];
  }
}

class TLRow{
  String label="";
  List<Character> items=[];

  TLRow(this.label, this.items);
}