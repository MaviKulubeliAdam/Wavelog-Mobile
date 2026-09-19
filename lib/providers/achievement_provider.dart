import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/achievement_model.dart';
import 'qso_provider.dart';
import 'remote_datasource_provider.dart';
import 'statistics_provider.dart';

// Achievements belong to the operator, not to a single callsign/logbook, so
// they intentionally use instance-wide numbers instead of the active scope.
final achievementInputProvider = FutureProvider<AchievementInput>((ref) async {
  final serverStats = await ref.watch(statisticsProvider.future);
  await ref.watch(logbookSummaryProvider.future);
  final stats = ref.read(qsoCacheDatasourceProvider).computeStats();
  return AchievementInput(
    totalQsos: serverStats.totalQsos,
    uniqueCallsigns: stats.uniqueCallsigns,
    bandsWorked: stats.byBand.length,
    streakDays: stats.currentStreakDays,
  );
});

final unlockedAchievementsProvider = FutureProvider<List<AchievementDef>>((ref) async {
  final input = await ref.watch(achievementInputProvider.future);
  return allAchievements.where((a) => a.isUnlocked(input)).toList();
});
