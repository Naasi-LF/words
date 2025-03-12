import '../models/word.dart';
import '../models/database/word_dao.dart';

class WordController {
  final WordDao _wordDao = WordDao();
  
  // 获取指定批次的所有单词
  Future<List<Word>> getWordsInLesson(int lessonId) async {
    return await _wordDao.getWordsByLesson(lessonId);
  }
  
  // 添加新单词
  Future<int> addWord(String word, String meaning, int lessonId) async {
    return await _wordDao.insertWord(
      Word(word: word, meaning: meaning, lessonId: lessonId)
    );
  }
  
  // 更新单词
  Future<int> updateWord(Word word) async {
    return await _wordDao.updateWord(word);
  }
  
  // 删除单词
  Future<int> deleteWord(int id) async {
    return await _wordDao.deleteWord(id);
  }
}