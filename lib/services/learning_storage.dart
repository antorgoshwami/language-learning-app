
import 'package:shared_preferences/shared_preferences.dart';

class LearningStorage {
  static const String _learnedKey = 'learned_lessons';
  static const String _scoreKey = 'best_quiz_score';

  static Future<Set<String>> loadLearned() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_learnedKey) ?? []).toSet();
  }

  static Future<void> saveLearned(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_learnedKey, ids.toList());
  }

  static Future<int> loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_scoreKey) ?? 0;
  }

  static Future<void> saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final best = prefs.getInt(_scoreKey) ?? 0;

    if (score > best) {
      await prefs.setInt(_scoreKey, score);
    }
  }
}
