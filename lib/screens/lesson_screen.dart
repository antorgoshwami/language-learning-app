
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models/lesson.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final bool initiallyLearned;
  final Future<void> Function(String id) onLearned;

  const LessonScreen({
    super.key,
    required this.lesson,
    required this.initiallyLearned,
    required this.onLearned,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final FlutterTts tts = FlutterTts();
  bool showTranslation = false;
  late bool learned;

  @override
  void initState() {
    super.initState();
    learned = widget.initiallyLearned;
    tts.setLanguage('en-US');
    tts.setSpeechRate(0.45);
  }

  Future<void> speak() async {
    await tts.stop();
    await tts.speak(widget.lesson.title);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FC),
      appBar: AppBar(
        title: Text(lesson.category),
        backgroundColor: const Color(0xFFF5F6FC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              lesson.category.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF6558F5),
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_stories,
                        size: 44,
                        color: Color(0xFF6558F5),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        lesson.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        lesson.example,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 18),
                      IconButton.filledTonal(
                        onPressed: speak,
                        icon: const Icon(Icons.volume_up),
                        tooltip: 'Listen to pronunciation',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pronunciation guide: ${lesson.pronunciation}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      if (showTranslation)
                        Text(
                          lesson.translation,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 23,
                            color: Color(0xFF6558F5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            showTranslation = !showTranslation;
                          });
                        },
                        child: Text(
                          showTranslation
                              ? 'Hide Translation'
                              : 'Show Translation',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: learned
                    ? null
                    : () async {
                        await widget.onLearned(lesson.id);
                        if (!mounted) return;
                        setState(() => learned = true);
                      },
                icon: Icon(
                  learned ? Icons.check_circle : Icons.school,
                ),
                label: Text(
                  learned ? 'Learned!' : 'Mark as Learned',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6558F5),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
