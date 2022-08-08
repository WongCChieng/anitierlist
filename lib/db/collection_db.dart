import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/collection/collection.dart';

class CollectionDB {
  Future<Database> createDB() async{
    final database = openDatabase(
        join(await getDatabasesPath(), "collection_database.db"),
        onCreate: (db,version){
          return db.execute("CREATE TABLE collections("
              "collectionId INTEGER PRIMARY KEY,"
              "collectionName TEXT,"
              "characters TEXT)");

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

}