import 'dart:async';

import 'package:anitierlist/models/tierlist/tierlist.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/collection/collection.dart';

class TierListDB {
  Future<Database> createDB() async{
    final database = openDatabase(
        join(await getDatabasesPath(), "tierlist_database.db"),
        onCreate: (db,version){
          return db.execute("CREATE TABLE tierlist("
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
    final List<Map<String, dynamic>> result = await db.query("tierlist",columns: ["tlId","listName,detailMap"]);

    List<TierList> tls = [];
    for (Map<String, dynamic> row in result ){
      tls.add(await TierList.fromMap(row));
    }
    return tls;
  }

}