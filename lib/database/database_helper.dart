import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static const _databaseName = "spill_database.db";
  static const _databaseVersion = 1;

  static const table = 'users';

  // Column names
  static const columnId = 'id';
  static const columnUsername = 'username';
  static const columnEmail = 'email';
  static const columnPhone = 'phone';
  static const columnName = 'name';
  static const columnGender = 'gender';
  static const columnDateOfBirth = 'dateOfBirth';
  static const columnProfileImagePath = 'profileImagePath';
  static const columnProfileVideoPath = 'profileVideoPath';
  static const columnEthnicity = 'ethnicity';
  static const columnHeight = 'height';
  static const columnLocation = 'location';
  static const columnInstagramHandle = 'instagramHandle';
  static const columnTiktokHandle = 'tiktokHandle';
  static const columnBio = 'bio';
  static const columnCreatedAt = 'createdAt';
  static const columnUpdatedAt = 'updatedAt';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUsername TEXT NOT NULL UNIQUE,
        $columnEmail TEXT NOT NULL UNIQUE,
        $columnPhone TEXT NOT NULL,
        $columnName TEXT NOT NULL,
        $columnGender TEXT NOT NULL,
        $columnDateOfBirth TEXT NOT NULL,
        $columnProfileImagePath TEXT,
        $columnProfileVideoPath TEXT,
        $columnEthnicity TEXT NOT NULL,
        $columnHeight REAL NOT NULL,
        $columnLocation TEXT NOT NULL,
        $columnInstagramHandle TEXT,
        $columnTiktokHandle TEXT,
        $columnBio TEXT,
        $columnCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT NOT NULL
      )
    ''');
  }

  // Insert a new user
  Future<int> insertUser(UserModel user) async {
    Database db = await instance.database;
    try {
      return await db.insert(table, user.toMap());
    } catch (e) {
      // Handle unique constraint violations
      if (e.toString().contains('UNIQUE constraint failed')) {
        if (e.toString().contains('username')) {
          throw Exception('Username already exists');
        } else if (e.toString().contains('email')) {
          throw Exception('Email already exists');
        }
      }
      throw Exception('Failed to create user: $e');
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // Get user by username
  Future<UserModel?> getUserByUsername(String username) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnUsername = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // Get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnEmail = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // Get user by phone
  Future<UserModel?> getUserByPhone(String phone) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnPhone = ?',
      whereArgs: [phone],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // Update user
  Future<int> updateUser(UserModel user) async {
    Database db = await instance.database;
    return await db.update(
      table,
      user.copyWith(updatedAt: DateTime.now()).toMap(),
      where: '$columnId = ?',
      whereArgs: [user.id],
    );
  }

  // Delete user
  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  // Search users by name or username
  Future<List<UserModel>> searchUsers(String query) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnName LIKE ? OR $columnUsername LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    final user = await getUserByUsername(username);
    return user != null;
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // Check if phone exists
  Future<bool> phoneExists(String phone) async {
    final user = await getUserByPhone(phone);
    return user != null;
  }

  // Authenticate user (for login)
  Future<UserModel?> authenticateUser(String usernameOrPhoneOrEmail, String password) async {
    // Note: In a real app, you would hash and compare passwords
    // For now, we'll just find the user by username/phone/email
    // You should implement proper password hashing with packages like crypto
    
    UserModel? user = await getUserByUsername(usernameOrPhoneOrEmail);
    user ??= await getUserByEmail(usernameOrPhoneOrEmail);
    user ??= await getUserByPhone(usernameOrPhoneOrEmail);
    
    return user;
  }

  // Close database
  Future<void> close() async {
    Database db = await instance.database;
    db.close();
  }
}
