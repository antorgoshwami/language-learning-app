
import 'dart:math';
import 'package:flutter/material.dart';

import '../data/lesson_data.dart';
import '../models/lesson.dart';
import '../services/learning_storage.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Random random = Random();

  late List<Lesson> questions;
  late List<List<String>> allOptions;

  int index = 0;
  int score = 0;
  int? selected;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    prepareQuiz();
  }

  void prepareQuiz() {
    questions = List<Lesson>.from(lessons)..shuffle(random);
    questions = questions.take(min(5, questions.length)).toList();

    allOptions = questions.map((question) {
      final wrongAnswers = lessons
          .where((lesson) =>
              lesson.translation != question.translation)
          .map((lesson) => lesson.translation)
          .toSet()
          .toList()
        ..shuffle(random);

      return <String>[
        question.translation,
        ...wrongAnswers.take(3),
      ]..shuffle(random);
    }).toList();
  }

  void nextQuestion() {
    if (selected == null) return;

    if (allOptions[index][selected!] ==
        questions[index].translation) {
      score++;
    }

    if (index == questions.length - 1) {
      setState(() => finished = true);
      LearningStorage.saveBestScore(score);
    } else {
      setState(() {
        index++;
        selected = null;
      });
    }
  }

  void restartQuiz() {
    setState(() {
      index = 0;
      score = 0;
      selected = null;
      finished = false;
      prepareQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Result')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 20),
              const Text(
                'Quiz Completed!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your score: $score / ${questions.length}',
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: restartQuiz,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[index];
    final options = allOptions[index];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FC),
      appBar: AppBar(
        title: const Text('Practice Quiz'),
        backgroundColor: const Color(0xFFF5F6FC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (index + 1) / questions.length,
              color: const Color(0xFF6558F5),
            ),
            const SizedBox(height: 18),
            Text('Question ${index + 1} of ${questions.length}'),
            const SizedBox(height: 26),
            const Text(
              'Choose the correct translation:',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 12),
            Text(
              question.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(options.length, (i) {
              final isSelected = selected == i;

              return Card(
                color: isSelected
                    ? const Color(0xFFE9E7FF)
                    : Colors.white,
                child: ListTile(
                  title: Text(options[i]),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF6558F5),
                        )
                      : null,
                  onTap: () => setState(() => selected = i),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: selected == null ? null : nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6558F5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: Text(
                index == questions.length - 1
                    ? 'Finish Quiz'
                    : 'Next Question',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
