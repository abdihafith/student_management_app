import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('student_records.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE student_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        course TEXT NOT NULL,
        admission_number TEXT NOT NULL UNIQUE
      )
    ''');
  }

  // --- CRUD & SEARCH FUNCTIONS ---

  // 1. Create (Insert)
  Future<int> insertRecord(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('student_records', row);
  }

  // 2. Read (Query All)
  Future<List<Map<String, dynamic>>> queryAllRecords() async {
    final db = await instance.database;
    return await db.query('student_records', orderBy: 'name ASC');
  }

  // 3. Update
  Future<int> updateRecord(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];
    return await db.update(
      'student_records',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 4. Delete
  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(
      'student_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 5. Search
  Future<List<Map<String, dynamic>>> searchRecords(String query) async {
    final db = await instance.database;
    return await db.query(
      'student_records',
      where: 'name LIKE ? OR admission_number LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
  }
}