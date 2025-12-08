import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/booking.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('srh_hotel.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Ensure the directory exists (only on mobile/desktop)
    if (!kIsWeb) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
    }

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        checkIn TEXT NOT NULL,
        checkOut TEXT NOT NULL,
        roomType TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');
  }

  Future<int> insertBooking(Booking booking) async {
    final db = await instance.database;
    return await db.insert('bookings', booking.toMap());
  }

  Future<List<Booking>> getBookings() async {
    final db = await instance.database;
    final result = await db.query('bookings');
    return result.map((json) => Booking.fromMap(json)).toList();
  }

  Future<int> deleteBooking(int id) async {
    final db = await instance.database;
    return await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }
}
