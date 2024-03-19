import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<Database> initDb() async {
    return sql.openDatabase(
      'cardProduct30.db', //database name
      version: 1, //version number
      onCreate: (Database database, int version) async {
        await createTable(database);
      },
    );
  }

  static Future<void> createTable(Database database) async {
    await database.execute("""
        CREATE TABLE card(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        idProduct TEXT,
        homecareID TEXT,
        image TEXT,
        quantity NUMERIC)
      """);
    debugPrint("table Created");
  }

  // id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  // title TEXT,
  // idProduct TEXT,
  // price NUM,
  // image TEXT,
  // quantity INTEGER,
  //add
  static Future<dynamic> addCard({
    required String idProduct,
    required num quantity,
    required String homecareID,
    required String image
  }) async {
    final db = await SQLHelper.initDb(); //open database
    final data = {
      'idProduct': idProduct,
      'homecareID':homecareID,
      'quantity': quantity,
      'image':image
    }; //create data in map
    var id;
    if (quantity == 0) {
      await db.delete("card", where: "idProduct = ?",
          whereArgs: [idProduct]);

    }
    else {
      await db.update('card', {'quantity': quantity},
          where: "idProduct = ?", whereArgs: [idProduct]);
      await db.query('card',
          where: "idProduct = ?", whereArgs: [idProduct]).then((value) async {
        if (value.isNotEmpty) {
          print(value.first);
        } else {
          print(data);
          id = await db.insert('card', data); //insert
          debugPrint("Data Added");
        }
      });
      print('update');
    }

    return id;
  }
  static Future<dynamic> deleteCardOrder({
    required String idProduct,

  }) async {
    final db = await SQLHelper.initDb(); //open database
    //create data in map
    var id;

    await db.delete('card',
        where: "idProduct = ?", whereArgs: [idProduct]);

    return id;
  }
  static Future<dynamic> updateCardOrder({
    required String idProduct,
    required num quantity,

  }) async {
    print(quantity);
    final db = await SQLHelper.initDb(); //open database
   //create data in map
    var id;

      await db.update('card', {'quantity': quantity},
          where: "idProduct = ?", whereArgs: [idProduct]);

    return id;
  }

//read all plants
  static Future<List<Map<String, dynamic>>> getCard() async {
    final db = await SQLHelper.initDb();
    return db.query('card', orderBy: "id");
  }

  //get plant by id
  static Future<List<Map<String, dynamic>>> getDeleteCardID(int id) async {
    final db = await SQLHelper.initDb();
    return db.query('card', where: "id = ?", whereArgs: [id]);
  }

  //update
  static Future<int> updateCard(
      int id, String title, String? descrption) async {
    final db = await SQLHelper.initDb();
    final data = {
      'title': title,
      'description': descrption,
    };

    final result =
        await db.update('card', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteCard(int id) async {
    final db = await SQLHelper.initDb();
    try {
      await db.delete("card", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong when : $err");
    }
  }

  static Future<void> deleteTable(int id) async {
    final db = await SQLHelper.initDb();
    try {
      await db.delete("card");
    } catch (err) {
      print("Something went wrong when : $err");
    }
  }
}
