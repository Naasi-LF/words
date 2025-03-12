import 'package:flutter/material.dart';
import '../../models/word.dart';

class WordItem extends StatelessWidget {
  final Word word;
  final bool isMeaningVisible;
  final Function(int) onTap;
  final Function(Word)? onEdit;
  final Function(int)? onDelete;
  final bool isEditable;

  const WordItem({
    Key? key,
    required this.word,
    required this.isMeaningVisible,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.isEditable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: () {
          if (word.id != null) {
            onTap(word.id!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.word,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isEditable) 
                      Text(
                        word.meaning,
                        style: const TextStyle(fontSize: 16),
                      )
                    else
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isMeaningVisible
                          ? Text(
                              word.meaning,
                              key: ValueKey(true),
                              style: const TextStyle(fontSize: 16),
                            )
                          : const Text(
                              'Tap to reveal meaning', // 保留英文
                              key: ValueKey(false),
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                      ),
                  ],
                ),
              ),
              if (isEditable) ...[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onEdit!(word),
                  tooltip: 'Edit', // 保留英文
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete!(word.id!),
                  tooltip: 'Delete', // 保留英文
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
