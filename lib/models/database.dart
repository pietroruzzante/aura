import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DatabaseHelper {
  static final DatabaseHelper _singleton = DatabaseHelper._internal();
  late Database _db;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _singleton;
  }

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = '${directory.path}/my_database.db';
    final dbFactory = databaseFactoryIo;
    _db = await dbFactory.openDatabase(dbPath);

    // Check if the database is empty and initialize it
    final store = StoreRef.main();
    if ((await store.count(_db)) == 0) {
      await _initializeDatabase();
    }
  }

  Future<void> _initializeDatabase() async {
    try {
      final jsonString = await rootBundle.loadString('assets/database.json');
      Map<String, dynamic> jsonResponse = json.decode(jsonString);
      final store = StoreRef.main();
      await _db.transaction((txn) async {
        for (var entry in jsonResponse.entries) {
          await store.record(entry.key).put(txn, entry.value);
        }
      });
      print('Database initialized with JSON data');
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Database get db => _db;
}

class MyDatabase {
  static final MyDatabase _singleton = MyDatabase._internal();
  final StoreRef<String, List<dynamic>> _store = StoreRef.main();

  MyDatabase._internal();

  factory MyDatabase() {
    return _singleton;
  }

  Future<void> init() async {
    await DatabaseHelper().init();
  }

  Future<void> insertRecord(String key, List<dynamic> value) async {
    await _store.record(key).put(DatabaseHelper().db, value);
  }

  Future<List<dynamic>?> getRecord(String key) async {
    return await _store.record(key).get(DatabaseHelper().db);
  }

  Future<void> updateRecord(String key, List<dynamic> value) async {
    await _store.record(key).update(DatabaseHelper().db, value);
  }

  Future<void> deleteRecord(String key) async {
    await _store.record(key).delete(DatabaseHelper().db);
  }


  Future<Map<String, List<dynamic>>> getAllRecords() async {
    final records = await _store.find(DatabaseHelper().db);
    return Map.fromEntries(records.map((record) => MapEntry(record.key, record.value)));
  }

  bool dateEquals(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}
