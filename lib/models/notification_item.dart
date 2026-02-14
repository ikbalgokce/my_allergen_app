class NotificationItem {
  final int id;
  final String type; // 'ilac', 'alerji', 'sistem'
  final String title;
  final String message;
  final String time;
  bool isRead;
  final String priority; // 'low', 'medium', 'high'

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.priority,
  });
}