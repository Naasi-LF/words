import 'package:flutter/material.dart';
import '../../controllers/word_controller.dart';
import '../../controllers/lesson_controller.dart';
import '../../models/word.dart';
import '../widgets/word_item.dart';
import '../widgets/add_button.dart';

class LessonEditorScreen extends StatefulWidget {
  final int lessonId;
  
  const LessonEditorScreen({Key? key, required this.lessonId}) : super(key: key);

  @override
  State<LessonEditorScreen> createState() => _LessonEditorScreenState();
}

class _LessonEditorScreenState extends State<LessonEditorScreen> {
  final WordController _wordController = WordController();
  final LessonController _lessonController = LessonController();
  late Future<List<Word>> _wordsFuture;
  String _lessonName = "Lesson Editor"; // 保留英文

  @override
  void initState() {
    super.initState();
    _refreshWords();
    _loadLessonName();
  }
  
  Future<void> _loadLessonName() async {
    final lessons = await _lessonController.getAllLessons();
    for (var lesson in lessons) {
      if (lesson.id == widget.lessonId) {
        setState(() {
          _lessonName = lesson.name;
        });
        break;
      }
    }
  }

  void _refreshWords() {
    setState(() {
      _wordsFuture = _wordController.getWordsInLesson(widget.lessonId);
    });
  }

  Future<void> _showWordDialog({Word? word}) async {
    final TextEditingController wordController = TextEditingController(text: word?.word ?? '');
    final TextEditingController meaningController = TextEditingController(text: word?.meaning ?? '');
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(word == null ? 'Add New Word' : 'Edit Word'), // 保留英文
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: wordController,
                decoration: const InputDecoration(
                  labelText: 'Word', // 保留英文
                  hintText: 'Enter a word', // 保留英文
                ),
                autofocus: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: meaningController,
                decoration: const InputDecoration(
                  labelText: 'Meaning', // 保留英文
                  hintText: 'Enter the meaning', // 保留英文
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'), // 保留英文
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(word == null ? 'Add' : 'Save'), // 保留英文
            ),
          ],
        );
      },
    );

    if (result == true && wordController.text.isNotEmpty && meaningController.text.isNotEmpty) {
      if (word == null) {
        await _wordController.addWord(wordController.text, meaningController.text, widget.lessonId);
      } else {
        await _wordController.updateWord(Word(
          id: word.id,
          word: wordController.text,
          meaning: meaningController.text,
          lessonId: widget.lessonId,
        ));
      }
      _refreshWords();
    }
  }

  Future<void> _deleteWord(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'), // 保留英文
          content: const Text('Are you sure you want to delete this word?'), // 保留英文
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'), // 保留英文
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'), // 保留英文
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _wordController.deleteWord(id);
      _refreshWords();
    }
  }

  Future<void> _deleteLesson() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Lesson'), // 保留英文
          content: const Text('Are you sure you want to delete this lesson and all its words? This action cannot be undone.'), // 保留英文
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'), // 保留英文
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'), // 保留英文
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _lessonController.deleteLesson(widget.lessonId);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit - $_lessonName'), // 保留英文前缀
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteLesson,
            tooltip: 'Delete Lesson', // 保留英文
          ),
        ],
      ),
      body: FutureBuilder<List<Word>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // 保留英文
          }

          final words = snapshot.data ?? [];
          
          if (words.isEmpty) {
            return const Center(child: Text('No words yet. Tap + to add one.')); // 保留英文
          }
          
          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              return WordItem(
                word: words[index],
                isMeaningVisible: true,
                onTap: (_) {},
                isEditable: true,
                onEdit: (word) => _showWordDialog(word: word),
                onDelete: _deleteWord,
              );
            },
          );
        },
      ),
      floatingActionButton: AddButton(
        onPressed: () => _showWordDialog(),
        tooltip: 'Add Word', // 保留英文
      ),
    );
  }
}
