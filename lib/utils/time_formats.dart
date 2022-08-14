const months = {
  1: 'januari',
  2: 'februari',
  3: 'maart',
  4: 'april',
  5: 'mei',
  6: 'juni',
  7: 'juli',
  8: 'augustus',
  9: 'september',
  10: 'oktober',
  11: 'november',
  12: 'december'
};

String formatDate(DateTime date, [bool includeYear = false])
{
  return '${date.day} ${months[date.month]}'
    + (includeYear || date.year != DateTime.now().year ? ' ${date.year}' : '');
}

String formatDateSpan(DateTime startDate, DateTime endDate)
{
  final excludeTime =
    startDate.hour == 0 && startDate.minute == 0
    && endDate.hour == 0 && endDate.minute == 0;

  return formatDate(startDate, startDate.year != endDate.year)
    + (!excludeTime ? ' ${startDate.toIso8601String().substring(11, 16)}' : '')
    + (!startDate.isAtSameMomentAs(endDate) ? ' -' : '')
    + (startDate.day != endDate.day || endDate.difference(startDate).inDays >= 1 ? ' ${formatDate(endDate, startDate.year != endDate.year)}' : '')
    + (!excludeTime ? ' ${endDate.toIso8601String().substring(11, 16)}' : '');
}

String timeAgoSinceDate(DateTime date, {bool short = false})
{
  final date2 = DateTime.now();
  final difference = date.difference(date2);

  if (difference.inDays > 8) {
    return formatDate(date);
  }
  else if ((difference.inDays / 7).floor() >= 1) {
    return short ? '1w' : '1 week geleden';
  }
  else if (difference.inDays >= 2) {
    return short ? '${difference.inDays}d' : '${difference.inDays} dagen geleden';
  }
  else if (difference.inDays >= 1) {
    return short ? '1d' : '1 dag geleden';
  }
  else if (difference.inHours >= 2) {
    return short ? '${difference.inHours}u' : '${difference.inHours} uur geleden';
  }
  else if (difference.inHours >= 1) {
    return short ? '1u' : '1 uur geleden';
  }
  else if (difference.inMinutes >= 2) {
    return short ? '${difference.inMinutes} min.' : '${difference.inMinutes} minuten geleden';
  }
  else if (difference.inMinutes >= 1) {
    return short ? '1 min.' : '1 minuut geleden';
  }
  else if (difference.inSeconds >= 3) {
    return short ? '${difference.inSeconds}s' : '${difference.inSeconds} seconden geleden';
  }
  else {
    return 'nu';
  }
}

String timeLeftBeforeDate(DateTime date, {bool short = false})
{
  final date2 = DateTime.now();
  final difference = date.difference(date2);

  if (short) return timeAgoSinceDate(date, short: true);

  if (difference.inDays > 8) {
    return formatDate(date);
  }
  else if ((difference.inDays / 7).floor() >= 1) {
    return 'over 1 week';
  }
  else if (difference.inDays >= 2) {
    return 'over ${difference.inDays} dagen';
  }
  else if (difference.inDays >= 1) {
    return 'over 1 dag';
  }
  else if (difference.inHours >= 2) {
    return 'over ${difference.inHours} uur';
  }
  else if (difference.inHours >= 1) {
    return 'over 1 uur';
  }
  else if (difference.inMinutes >= 2) {
    return 'over ${difference.inMinutes} minuten';
  }
  else if (difference.inMinutes >= 1) {
    return 'over 1 minuut';
  }
  else if (difference.inSeconds >= 3) {
    return 'over ${difference.inSeconds} seconden';
  }
  else {
    return 'nu';
  }
}
