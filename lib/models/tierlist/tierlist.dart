import 'dart:convert';

import 'package:anitierlist/models/character/character.dart';

class TierList{
  int? tlId;
  String listName='';
  String detailMap='';
  List<TLRow> rows=[
    TLRow(0,"S", []),
    TLRow(1,"A", []),
    TLRow(2,"B", []),
    TLRow(3,"C", []),];
  int? collectionId;
  String unusedCharacters="";
  List<Character> unused = [];

  TierList({
    this.tlId,
    required this.listName,
    required this.detailMap,
    required this.rows,
    required this.collectionId,
    required this.unusedCharacters, required unused
  });

  void mapJsonToRows(Map<String,dynamic> json){
    int count=0;
    json.forEach((key, value) {
      rows.add(TLRow(count,key,jsonDecode(value)));
      count+=1;
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

  @override
  String toString() {
    return listName +"\n"+rows.toString()+"\n"+collectionId.toString()+"\n"+unusedCharacters;
  }
}

class TLRow{
  int? index;
  String label="";
  List<Character> items=[];

  TLRow(this.index,this.label, this.items);

  String toString(){
    String s = "";
    for (Character c in items){
      s+=c.name+" ";
    }
    return "$index = $label: $s";
  }
}