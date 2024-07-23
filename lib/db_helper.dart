// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_authentication/model/customer.dart';

class DBHelper {
  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();

    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'user_auth.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> saveAuthInfo(
      String authToken, String email, String password) async {
    await _secureStorage.write(key: 'authToken', value: authToken);
    final db = await instance.database;
    await db.rawInsert(
        'INSERT INTO auth (authToken, email, password) VALUES(?, ?, ?)',
        [authToken, email, password]);
  }

  Future<Map<String, String>?> getAuthInfo() async {
    final db = await instance.database;
    final result = await db.query('auth', limit: 1);

    if (result.isNotEmpty) {
      return {
        'authToken': result.first['authToken'] as String,
        'email': result.first['email'] as String,
        'password': result.first['password'] as String,
      };
    } else {
      String? authToken = await _secureStorage.read(key: 'authToken');
      String? email = await _secureStorage.read(key: 'email');
      String? password = await _secureStorage.read(key: 'password');
      return {
        'authToken': authToken.toString(),
        'email': email.toString(),
        'password': password.toString(),
      };
    }
  }

  Future<void> clearAuthInfo() async {
    await _secureStorage.deleteAll();
    final db = await instance.database;
    await db.delete('auth');
  }

  Future<void> saveAuthToken(String authToken) async {
    final db = await instance.database;
    await db.rawInsert('INSERT INTO auth (authToken) VALUES(?)', [authToken]);
  }

  Future<String?> getAuthToken() async {
    final db = await instance.database;
    final result = await db.query('auth', limit: 1);
    return result.isNotEmpty ? result.first['authToken'] as String : null;
  }

  Future<void> setUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    await db.insert('user', user);
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await instance.database;
    final result =
        await db.query('user', where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateUserPassword(String email, String newPassword) async {
    final db = await instance.database;
    await db.update(
      'user',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> saveImage(String imageName, Uint8List imageBytes) async {
    final db = await instance.database;
    await db.insert('images', {'name': imageName, 'data': imageBytes},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Uint8List?> loadImage(String imageName) async {
    final db = await instance.database;
    final result = await db.query('images',
        columns: ['data'], where: 'name = ?', whereArgs: [imageName], limit: 1);

    if (result.isNotEmpty) {
      return result.first['data'] as Uint8List?;
    }

    return null;
  }

  Future<void> createCustomer(Customer customer) async {
    try {
      final db = await instance.database;
      await db.insert(
        'customers',
        {
          'customerId': customer.customerId,
          'name': customer.name,
          'mobile': customer.mobile,
          'email': customer.email,
          'address': customer.address,
          'latitude': customer.latitude,
          'longitude': customer.longitude,
          'imagePath': customer.imagePath,
          'imageData': customer.imageData,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Customer added successfully');
    } catch (e) {
      print('Error saving customer: $e');
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      final db = await instance.database;
      await db.update(
        'customers',
        {
          'name': customer.name,
          'mobile': customer.mobile,
          'email': customer.email,
          'address': customer.address,
          'latitude': customer.latitude,
          'longitude': customer.longitude,
          'imagePath': customer.imagePath,
          'imageData': customer.imageData,
        },
        where: 'customerId = ?',
        whereArgs: [customer.customerId],
      );
      print('Customer updated successfully');
    } catch (e) {
      print('Error updating customer: $e');
    }
  }

  Future<void> removeCustomer(String customerId) async {
    final db = await instance.database;
    await db
        .delete('customers', where: 'customerId = ?', whereArgs: [customerId]);
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (i) => Customer.fromMap(maps[i]));
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        userId INTEGER PRIMARY KEY,
        authToken TEXT,
        name TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE auth (
      authId INTEGER PRIMARY KEY,
      authToken TEXT,
      email TEXT,
      password TEXT
    )
  ''');

    await db.execute('''
      CREATE TABLE customers (
        customerId TEXT PRIMARY KEY,
        imagePath TEXT,
        imageData BLOB,
        name TEXT,
        mobile TEXT,
        email TEXT,
        address TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');
  }
}
