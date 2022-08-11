import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/collection/collection.dart';
import '../models/tierlist/tierlist.dart';

class AniTierList {
  Future<Database> createDB() async{
    final database = openDatabase(
        join(await getDatabasesPath(), "collection_database.db"),
        onCreate: (db,version) async{
            await db.execute("CREATE TABLE collections("
              "collectionId INTEGER PRIMARY KEY,"
              "collectionName TEXT,"
              "characters TEXT)");
            await db.execute("CREATE TABLE tierlist("
                "tlId INTEGER PRIMARY KEY,"
                "listName TEXT,"
                "detailMap TEXT,"
                "collectionId INTEGER,"
                "unusedCharacters TEXT)");
        },
        version: 1
    );
    return database;
  }

  Future<void> insertCollection(Collection collection) async{
    final db = await createDB();
    await db.insert("collections", collection.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCollection(int cID) async{
    final db = await createDB();
    await db.delete("collections",where: 'collectionId=?',whereArgs: [cID]);
    await db.delete("tierlist",where: 'collectionId=?',whereArgs: [cID]);
  }

  Future<void> updateCollection(Collection collection) async{
    final db = await createDB();
    await db.update("collections",collection.toMap(),where: 'collectionId=?',whereArgs: [collection.collectionId]);
  }

  Future<List<Collection>> getCollections() async{
    final db = await createDB();
    final List<Map<String, dynamic>> result = await db.query("collections",columns: ["collectionId","collectionName,characters"]);

    List<Collection> collections = [];
    for (Map<String, dynamic> row in result ){
      collections.add(await Collection.fromMap(row));
    }
    return collections;
  }

  Future<void> insertTL(TierList tierList) async{
    final db = await createDB();
    await db.insert("tierlist", tierList.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTL(int cID) async{
    final db = await createDB();
    await db.delete("tierlist",where: 'tlId=?',whereArgs: [cID]);
  }

  Future<void> updateTL(TierList tierList) async{
    final db = await createDB();
    await db.update("tierlist",tierList.toMap(),where: 'tlId=?',whereArgs: [tierList.tlId]);
  }

  Future<List<TierList>> getTLs() async{
    final db = await createDB();
    final List<Map<String, dynamic>> result = await db.query("tierlist",columns: ["tlId","listName,detailMap,unusedCharacters,collectionId"]);

    List<TierList> tls = [];
    for (Map<String, dynamic> row in result ){
      tls.add(TierList.fromMap(row));
    }
    return tls;
  }

}