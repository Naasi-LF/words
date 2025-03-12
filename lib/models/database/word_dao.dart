import 'package:sqflite/sqflite.dart';
import '../word.dart';
import '../lesson.dart';
import 'database_helper.dart';

class WordDao {
  final dbHelper = DatabaseHelper.instance;
  
  // 插入新的批次
  Future<int> insertLesson(Lesson lesson) async {
    final db = await dbHelper.database;
    return await db.insert('lessons', lesson.toMap());
  }
  
  // 获取所有批次
  Future<List<Lesson>> getLessons() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('lessons');
    return List.generate(maps.length, (i) => Lesson.fromMap(maps[i]));
  }
  
  // 删除批次及其单词
  Future<int> deleteLesson(int id) async {
    final db = await dbHelper.database;
    await db.delete('words', where: 'lessonId = ?', whereArgs: [id]);
    return await db.delete('lessons', where: 'id = ?', whereArgs: [id]);
  }
  
  // 插入新单词
  Future<int> insertWord(Word word) async {
    final db = await dbHelper.database;
    return await db.insert('words', word.toMap());
  }
  
  // 根据批次ID获取单词列表
  Future<List<Word>> getWordsByLesson(int lessonId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'words',
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
    return List.generate(maps.length, (i) => Word.fromMap(maps[i]));
  }
  
  // 更新单词
  Future<int> updateWord(Word word) async {
    final db = await dbHelper.database;
    return await db.update(
      'words',
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }
  
  // 删除单词
  Future<int> deleteWord(int id) async {
    final db = await dbHelper.database;
    return await db.delete('words', where: 'id = ?', whereArgs: [id]);
  }
}