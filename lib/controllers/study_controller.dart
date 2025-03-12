import 'package:flutter/material.dart';
import '../models/word.dart';

class StudyController {
  // 用于控制单词意思显示状态的Map
  final Map<int, bool> _meaningVisibility = {};
  
  // 初始化单词列表的可见性状态
  void initVisibility(List<Word> words) {
    for (var word in words) {
      if (word.id != null && !_meaningVisibility.containsKey(word.id)) {
        _meaningVisibility[word.id!] = false;
      }
    }
  }
  
  // 切换单个单词的意思显示状态
  bool toggleWordVisibility(int wordId) {
    if (!_meaningVisibility.containsKey(wordId)) {
      _meaningVisibility[wordId] = false;
    }
    _meaningVisibility[wordId] = !_meaningVisibility[wordId]!;
    return _meaningVisibility[wordId]!;
  }
  
  // 获取单词的意思显示状态
  bool isWordVisible(int wordId) {
    return _meaningVisibility[wordId] ?? false;
  }
  
  // 隐藏所有单词的意思
  void hideAllMeanings() {
    _meaningVisibility.updateAll((key, value) => false);
  }
  
  // 显示所有单词的意思
  void showAllMeanings() {
    _meaningVisibility.updateAll((key, value) => true);
  }
}