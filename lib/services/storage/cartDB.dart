import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDatabase {
  static final CartDatabase instance = CartDatabase._init();
  static Database? _database;

  CartDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cart (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      productId TEXT,
      name TEXT,
      image TEXT,
      quantity INTEGER,
      restaurant_id INTEGER,
      price REAL,
      description TEXT,
      options TEXT,
      ingredients TEXT,
      totalPrice TEXT
    )
  ''');
  }


  Future<int> addItem(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.insert('cart', item, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await instance.database;
    return await db.query('cart');
  }

  Future<int> updateItem(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.update('cart', item, where: 'id = ?', whereArgs: [item['id']]);
  }

  Future<int> deleteItem(int id) async {
    final db = await instance.database;
    return await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearCart() async {
    final db = await instance.database;
    return await db.delete('cart');
  }
}
