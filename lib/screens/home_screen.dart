
import 'package:flutter/material.dart';

import '../data/lesson_data.dart';
import '../models/lesson.dart';
import '../services/learning_storage.dart';
import '../widgets/lesson_card.dart';
import 'lesson_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<String> learnedIds = {};
  String selectedCategory = 'All';
  int bestScore = 0;
  bool loading = true;

  final categories = ['All', 'Vocabulary', 'Phrases', 'Grammar'];

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final learned = await LearningStorage.loadLearned();
    final score = await LearningStorage.loadBestScore();

    if (!mounted) return;

    setState(() {
      learnedIds = learned;
      bestScore = score;
      loading = false;
    });
  }

  Future<void> markLearned(String id) async {
    learnedIds.add(id);
    await LearningStorage.saveLearned(learnedIds);

    if (!mounted) return;
    setState(() {});
  }

  Future<void> openLesson(Lesson lesson) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonScreen(
          lesson: lesson,
          initiallyLearned: learnedIds.contains(lesson.id),
          onLearned: markLearned,
        ),
      ),
    );

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredLessons = lessons.where((lesson) {
      return selectedCategory == 'All' ||
          lesson.category == selectedCategory;
    }).toList();

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FC),
      appBar: AppBar(
        title: const Text(
          'Language Learning App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F6FC),
        actions: [
          IconButton(
            tooltip: 'Practice quiz',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuizScreen(),
                ),
              );
              await loadProgress();
            },
            icon: const Icon(Icons.quiz_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6558F5),
                  Color(0xFF9288FF),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Learn a little every day',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${learnedIds.length} of ${lessons.length} lessons completed',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: learnedIds.length / lessons.length,
                  backgroundColor: Colors.white30,
                  color: Colors.white,
                  minHeight: 8,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Best quiz score: $bestScore',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Learning Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final selected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => selectedCategory = category);
                    },
                    selectedColor: const Color(0xFFDCD8FF),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Daily Lessons',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text('${filteredLessons.length} lessons'),
            ],
          ),
          const SizedBox(height: 12),
          ...filteredLessons.map(
            (lesson) => LessonCard(
              lesson: lesson,
              isLearned: learnedIds.contains(lesson.id),
              onTap: () => openLesson(lesson),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QuizScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Practice Quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6558F5),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
