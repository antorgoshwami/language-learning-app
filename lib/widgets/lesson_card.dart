
import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final bool isLearned;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.isLearned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE9E7FF),
          child: Icon(
            lesson.category == 'Grammar'
                ? Icons.menu_book
                : lesson.category == 'Phrases'
                    ? Icons.chat_bubble_outline
                    : Icons.translate,
            color: const Color(0xFF6558F5),
          ),
        ),
        title: Text(
          lesson.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${lesson.category} • ${lesson.translation}',
          ),
        ),
        trailing: Icon(
          isLearned ? Icons.check_circle : Icons.arrow_forward_ios,
          size: isLearned ? 24 : 17,
          color: isLearned ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
