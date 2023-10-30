import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final String name;
  final String lastLevel;
  final String subLevel; // Tambahkan field subLevel
  final int score;

  User({
    required this.name,
    required this.lastLevel,
    required this.subLevel, // Tambahkan field subLevel
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastLevel': lastLevel,
      'subLevel': subLevel, // Tambahkan field subLevel
      'score': score,
    };
  }
}

class DatabaseUser {
  static final DatabaseUser _instance = DatabaseUser._privateConstructor();

  factory DatabaseUser() {
    return _instance;
  }

  DatabaseUser._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = await getDatabasesPath();
    final dbPath = join(path, 'user_database.db');
    return await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          lastLevel TEXT,
          subLevel TEXT,
          score INTEGER
        )
      ''');
      },
      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    final Database db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUsers() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User(
        name: maps[i]['name'],
        lastLevel: maps[i]['lastLevel'],
        subLevel: maps[i]['subLevel'], // Tambahkan pembacaan subLevel
        score: maps[i]['score'],
      );
    });
  }

  Future<List<String>> getUserNames() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return maps[i]['name'] as String;
    });
  }

  Future<void> deleteUserByName(String name) async {
    final Database db = await database;
    await db.delete(
      'users',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<int?> getScoreByName(String name) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      columns: ['score'],
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      // Jika ada pengguna dengan nama yang cocok, kembalikan skornya.
      return maps[0]['score'] as int?;
    } else {
      // Jika tidak ada pengguna dengan nama yang cocok, kembalikan null.
      return null;
    }
  }

  Future<User?> getUserByName(String name) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return User(
        name: maps[0]['name'],
        lastLevel: maps[0]['lastLevel'],
        subLevel: maps[0]['subLevel'],
        score: maps[0]['score'],
      );
    } else {
      return null; // Return null if no user with the given name is found
    }
  }

  Future<void> updateUserByName(
    String name, {
    String? lastLevel,
    String? subLevel,
    int? score,
  }) async {
    final Database db = await database;

    final Map<String, dynamic> updates = {};

    if (lastLevel != null) {
      updates['lastLevel'] = lastLevel;
    }

    if (subLevel != null) {
      updates['subLevel'] = subLevel;
    }

    if (score != null) {
      updates['score'] = score;
    }

    if (updates.isNotEmpty) {
      await db.update(
        'users',
        updates,
        where: 'name = ?',
        whereArgs: [name],
      );
    }
  }

  Future<int?> getUserIndexByName(String name) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      // Jika ada pengguna dengan nama yang cocok, kembalikan indeksnya.
      return maps[0]['id'] as int?;
    } else {
      // Jika tidak ada pengguna dengan nama yang cocok, kembalikan null.
      return null;
    }
  }
}
