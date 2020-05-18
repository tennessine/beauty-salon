import 'dart:async';
import 'dart:io';

import 'package:flutterapp/models/customer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  static Database _db;

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDB();
    }
    return _db;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'beauty_salon.db');
    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }

  dbPath() async {
    var dbClient = await db;
    return dbClient.path;
  }

  Future<List<Customer>> findCustomers(String phone) async {
    var dbClient = await db;

    final List<Map<String, dynamic>> customers = await dbClient.query(
      'customers',
      where: 'phone LIKE ?',
      whereArgs: ['$phone%']
    );
    return List.generate(customers.length, (index) {
      return Customer(
        id: customers[index]['id'],
        name: customers[index]['name'],
        age: customers[index]['age'],
        gender: customers[index]['gender'],
        birthday: customers[index]['birthday'],
        phone: customers[index]['phone'],
        occupation: customers[index]['occupation'],
        address: customers[index]['address'],
        mark: customers[index]['mark'],
      );
    });
  }

  Future<Customer> getCustomerRecord(String phone) async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient
        .rawQuery("SELECT * FROM `customers` WHERE phone = $phone");
    if (result.length == 0) {
      return null;
    }
    return Customer.fromMap(result.first);
  }

  Future<List<Customer>> getCustomerRecords() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> customers = await dbClient.query('customers');
    return List.generate(customers.length, (index) {
      print(customers[index]['age']);
      return Customer(
        id: customers[index]['id'],
        name: customers[index]['name'],
        age: customers[index]['age'],
        gender: customers[index]['gender'],
        birthday: customers[index]['birthday'],
        phone: customers[index]['phone'],
        occupation: customers[index]['occupation'],
        address: customers[index]['address'],
        mark: customers[index]['mark'],
      );
    });
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    const sql = '''
      CREATE TABLE `customers` (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        gender CHAR(1),
        birthday CHAR(10),
        phone CHAR(11),
        occupation TEXT,
        address TEXT,
        mark TEXT
      )
    ''';
    await db.execute(sql);
  }
  
  Future<int> deleteCustomer(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id]
    );
  }
  
  Future<int> saveCustomer(Customer customer) async {
    var dbClient = await db;
    return await dbClient.insert(
      'customers',
      customer.toMap()
    );
  }
  
  Future<int> updateCustomer(Customer customer) async {
    var dbClient = await db;
    return await dbClient.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id]
    );
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM `customers`'));
  }

  Future<void> close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
