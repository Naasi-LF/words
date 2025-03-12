import 'package:flutter/material.dart';
import '../../controllers/word_controller.dart';
import '../../controllers/study_controller.dart';
import '../../models/word.dart';
import '../../models/lesson.dart';
import '../widgets/word_item.dart';

class LessonStudyScreen extends StatefulWidget {
  final Lesson lesson;
  
  const LessonStudyScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  State<LessonStudyScreen> createState() => _LessonStudyScreenState();
}

class _LessonStudyScreenState extends State<LessonStudyScreen> {
  final WordController _wordController = WordController();
  final StudyController _studyController = StudyController();
  late Future<List<Word>> _wordsFuture;
  List<Word> _words = [];
  bool _allHidden = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    setState(() {
      _wordsFuture = _wordController.getWordsInLesson(widget.lesson.id!);
    });
    
    _words = await _wordsFuture;
    _studyController.initVisibility(_words);
  }

  void _toggleMeaning(int wordId) {
    setState(() {
      _studyController.toggleWordVisibility(wordId);
      
      bool allHidden = true;
      for (var word in _words) {
        if (_studyController.isWordVisible(word.id!)) {
          allHidden = false;
          break;
        }
      }
      _allHidden = allHidden;
    });
  }

  void _toggleAllMeanings() {
    setState(() {
      if (_allHidden) {
        _studyController.showAllMeanings();
        _allHidden = false;
      } else {
        _studyController.hideAllMeanings();
        _allHidden = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study - ${widget.lesson.name}'), // 保留英文前缀
      ),
      body: FutureBuilder<List<Word>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // 保留英文
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No words in this lesson')); // 保留英文
          }

          _words = snapshot.data!;
          
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _words.length,
            itemBuilder: (context, index) {
              final word = _words[index];
              return WordItem(
                word: word,
                isMeaningVisible: _studyController.isWordVisible(word.id!),
                onTap: _toggleMeaning,
                isEditable: false,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAllMeanings,
        tooltip: _allHidden ? 'Show All' : 'Hide All', // 保留英文
        child: Icon(_allHidden ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }
}
