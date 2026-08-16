import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/achievement_model.dart';
import 'detailed_statistics_provider.dart';
import 'remote_datasource_provider.dart';

final achievementInputProvider = FutureProvider<AchievementInput>((ref) async {
  final detailed = await ref.watch(detailedStatisticsProvider.future);
  final cache = ref.read(qsoCacheDatasourceProvider);
  final stats = cache.computeStats();
  return AchievementInput(
    totalQsos: detailed.totalQsos,
    uniqueCallsigns: detailed.uniqueCallsigns,
    bandsWorked: stats.byBand.length,
    streakDays: detailed.currentStreakDays,
  );
});

final unlockedAchievementsProvider = FutureProvider<List<AchievementDef>>((ref) async {
  final input = await ref.watch(achievementInputProvider.future);
  return allAchievements.where((a) => a.isUnlocked(input)).toList();
});
