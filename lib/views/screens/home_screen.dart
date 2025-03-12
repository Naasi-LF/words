import 'package:flutter/material.dart';
import '../../controllers/lesson_controller.dart';
import '../../models/lesson.dart';
import '../widgets/lesson_card.dart';
import '../widgets/add_button.dart';
import 'lesson_editor.dart';
import 'lesson_study.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LessonController _lessonController = LessonController();
  late Future<List<Lesson>> _lessonsFuture;

  @override
  void initState() {
    super.initState();
    _refreshLessons();
  }

  void _refreshLessons() {
    setState(() {
      _lessonsFuture = _lessonController.getAllLessons();
    });
  }

  void _addNewLesson() async {
    // 获取所有现有批次以生成建议名称
    final lessons = await _lessonController.getAllLessons();
    
    // 计算下一个批次序号
    int nextNumber = 1;
    
    // 查找所有L开头且后面是数字的批次名称
    List<int> existingNumbers = [];
    for (final lesson in lessons) {
      if (lesson.name.startsWith('L') && lesson.name.length > 1) {
        try {
          final number = int.parse(lesson.name.substring(1));
          existingNumbers.add(number);
        } catch (e) {
          // 忽略非数字格式
        }
      }
    }
    
    // 如果有现有的数字格式批次，找出最大值+1作为建议
    if (existingNumbers.isNotEmpty) {
      existingNumbers.sort();
      nextNumber = existingNumbers.last + 1;
    }
    
    // 设置建议批次名称
    final TextEditingController nameController = TextEditingController(text: 'L$nextNumber');
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Lesson'), // 保留英文
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Lesson Name', // 保留英文
              hintText: 'e.g., L1, L2, Basic Vocabulary...', // 保留英文
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'), // 保留英文
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Add'), // 保留英文
            ),
          ],
        );
      },
    );

    if (result == true && nameController.text.isNotEmpty) {
      await _lessonController.addLesson(nameController.text);
      _refreshLessons();
    }
  }

  void _navigateToLessonEditor(Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonEditorScreen(lessonId: lesson.id!),
      ),
    ).then((_) => _refreshLessons());
  }

  void _navigateToLessonStudy(Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonStudyScreen(lesson: lesson),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Words Study'), // 保留英文
      ),
      body: FutureBuilder<List<Lesson>>(
        future: _lessonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // 保留英文
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No lessons yet. Tap + to add one.')); // 保留英文
          }

          final lessons = snapshot.data!;
          
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return LessonCard(
                lesson: lesson,
                onTap: () => _navigateToLessonStudy(lesson),
                onEdit: () => _navigateToLessonEditor(lesson),
              );
            },
          );
        },
      ),
      floatingActionButton: AddButton(
        onPressed: _addNewLesson,
        tooltip: 'Add Lesson', // 保留英文
      ),
    );
  }
}
