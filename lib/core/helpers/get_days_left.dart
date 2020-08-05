import '../../features/event/models/event.dart';

String getDaysLeft(Event event) {
  final now = DateTime.now();
  final eventDate = DateTime.parse(event.dateString);

  final daysDifference = eventDate.difference(now).inDays;

  if (daysDifference < 1) return "< 1";

  return daysDifference.toString();
}
