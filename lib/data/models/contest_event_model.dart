class ContestEvent {
  final String title;
  final String description;
  final String link;
  final DateTime? startUtc;
  final DateTime? endUtc;

  const ContestEvent({
    required this.title,
    required this.description,
    required this.link,
    this.startUtc,
    this.endUtc,
  });

  bool get isToday {
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    if (startUtc == null) return false;
    final s = startUtc!;
    final e = endUtc ?? s.add(const Duration(hours: 24));
    return s.isBefore(tomorrow) && e.isAfter(today);
  }

  bool get isThisWeek {
    final now = DateTime.now().toUtc();
    final weekEnd = now.add(const Duration(days: 7));
    if (startUtc == null) return false;
    return startUtc!.isBefore(weekEnd) && !isToday;
  }

  bool get isPast {
    if (endUtc == null && startUtc == null) return false;
    final ref = endUtc ?? startUtc!.add(const Duration(hours: 48));
    return ref.isBefore(DateTime.now().toUtc());
  }
}
