// lib/database_helper.dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'question.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        option1 TEXT NOT NULL,
        option2 TEXT NOT NULL,
        option3 TEXT NOT NULL,
        option4 TEXT NOT NULL,
        answer TEXT NOT NULL
      )
    ''');

    // Questions d'exemple (tu peux en ajouter autant que tu veux)
    final List<Map<String, dynamic>> sampleQuestions = [
      {
        'question': 'Quelle est la capitale de la France ?',
        'option1': 'Madrid',
        'option2': 'Berlin',
        'option3': 'Rome',
        'option4': 'Paris',
        'answer': 'Paris'
      },
      {
        'question': 'Combien font 5 × 8 ?',
        'option1': '35',
        'option2': '40',
        'option3': '45',
        'option4': '48',
        'answer': '40'
      },
      {
        'question': 'Quel est le plus grand planète du système solaire ?',
        'option1': 'Terre',
        'option2': 'Mars',
        'option3': 'Jupiter',
        'option4': 'Saturne',
        'answer': 'Jupiter'
      },
      {
        'question': 'En quelle année l’Homme a-t-il marché sur la Lune ?',
        'option1': '1965',
        'option2': '1969',
        'option3': '1972',
        'option4': '1959',
        'answer': '1969'
      },
      {
        'question': 'Quel langage est utilisé pour Flutter ?',
        'option1': 'Java',
        'option2': 'Dart',
        'option3': 'Kotlin',
        'option4': 'Swift',
        'answer': 'Dart'
      },
    ];

    for (var q in sampleQuestions) {
      await db.insert('questions', q);
    }
  }

  Future<List<Question>> getQuestions() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('questions');

    return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
  }
}