import 'package:project_5_sqflite/constant.dart';
import 'package:project_5_sqflite/model/deleteTodo.dart';
import 'package:project_5_sqflite/model/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(LOCAL_DATABASE);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $todoTable(
      ${TodoField.id} TEXT NOT NULL UNIQUE,
      ${TodoField.title} TEXT,
      ${TodoField.done} BOOLEAN NOT NULL,
      ${TodoField.createdAt} TEXT,
      ${TodoField.updatedAt} TEXT
    )
    ''');

    await db.execute(''' 
        CREATE TABLE $todoTableCreate(
      ${TodoField.id} TEXT NOT NULL UNIQUE,
      ${TodoField.title} TEXT,
      ${TodoField.done} BOOLEAN NOT NULL,
      ${TodoField.createdAt} TEXT,
      ${TodoField.updatedAt} TEXT
    )
    ''');

    await db.execute(''' 
       CREATE TABLE $todoTableUpdate(
      ${TodoField.id} TEXT NOT NULL UNIQUE,
      ${TodoField.title} TEXT,
      ${TodoField.done} BOOLEAN NOT NULL,
      ${TodoField.createdAt} TEXT,
      ${TodoField.updatedAt} TEXT
    )
    ''');
    await db.execute(''' 
    CREATE TABLE $todoTableDelete(
      ${TodoField.id} TEXT NOT NULL
    )
    ''');
  }

  Future<Todo> create(Todo todo) async {
    final db = await _instance.database;
    await db.insert(todoTable, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await db.insert(todoTableCreate, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return todo;
  }

  Future<Todo> read(String id) async {
    final db = await _instance.database;
    final maps = await db.query(todoTable,
        columns: TodoField.values,
        where:
            '${TodoField.id} = ?', // ? Question Mark to prevent SQL INJECTION
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      throw Exception('ID $id is NOT FOUND');
    }
  }

  Future<List<Todo>> readAll(String table) async {
    final db = await _instance.database;
    final result =
        await db.query(table, orderBy: '${TodoField.updatedAt} DESC');
    return result.map((e) => Todo.fromMap(e)).toList();
  }

  Future<List<DeleteTodo>> readDeleted() async {
    final db = await _instance.database;
    final result = await db.query(todoTableDelete);
    return result.map((e) => DeleteTodo.fromMap(e)).toList();
  }

  Future<Todo> update(Todo todo) async {
    final db = await _instance.database;
    await db.update(todoTable, todo.toMap(),
        where: '${TodoField.id} = ?', whereArgs: [todo.id]);
    await db.insert(todoTableUpdate, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return todo;
  }

  Future<String> delete(String id) async {
    final db = await _instance.database;
    await db.delete(todoTable, where: '${TodoField.id} = ?', whereArgs: [id]);
    await db.insert(todoTableDelete, {"id": id});
    return id;
  }

  Future deleteTodos(String table) async {
    final db = await _instance.database;
    await db.delete(table);
    return;
  }

  Future deleteAll() async {
    final db = await _instance.database;
    db.delete(todoTable);
    db.delete(todoTableUpdate);
    db.delete(todoTableCreate);
    db.delete(todoTableDelete);
    return;
  }

  Future close() async {
    final db = await _instance.database;

    db.close();
  }
}
