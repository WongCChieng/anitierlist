import 'dart:convert';

import 'package:anitierlist/query/query.dart';
import 'package:flutter/cupertino.dart';

import '../character/character.dart';

class Collection{
  int? collectionId;
  String collectionName="";
  List<Character> characters=[];
  String charactersListString="";

  Collection({this.collectionId, required this.collectionName,required this.characters, required this.charactersListString});

  Map<String, dynamic> toMap(){
    return {
      'collectionId':collectionId,
      'collectionName':collectionName,
      'characters': idList(characters)
    };
  }

  String idList(List<Character>? char){
    List<String> result = [];
    for (Character c in char!){
      result.add(c.id.toString());
    }
    return result.toString();
  }

  static Future<Collection> fromMap(Map<String, dynamic> data) async{
    return Collection(
        collectionId: data["collectionId"],
        collectionName: data["collectionName"],
        charactersListString: data["characters"], characters: []);
  }


}