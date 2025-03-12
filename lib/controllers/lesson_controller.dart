import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/database/word_dao.dart';

class LessonController {
  final WordDao _wordDao = WordDao();
  
  // 获取所有批次
  Future<List<Lesson>> getAllLessons() async {
    return await _wordDao.getLessons();
  }
  
  // 添加新批次
  Future<int> addLesson(String name) async {
    return await _wordDao.insertLesson(Lesson(name: name));
  }
  
  // 删除批次及其单词
  Future<int> deleteLesson(int id) async {
    return await _wordDao.deleteLesson(id);
  }
}