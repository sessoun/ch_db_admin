
import 'package:ch_db_admin/src/notifications/domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.timestamp,
    super.isRead,
  });

  // Example of method to convert NotificationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  // Example of method to create NotificationModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }
}
