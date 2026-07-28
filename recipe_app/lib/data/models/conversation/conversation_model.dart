class ConversationModel {
  final int id;
  final String title;
  final int messageCount;
  final String createdAt;
  final String updatedAt;
  final List<MessageModel> messages;

  ConversationModel({
    required this.id,
    required this.title,
    required this.messageCount,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      title: json['title'] ?? '',
      messageCount: json['message_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      messages: json['messages'] != null
          ? List<MessageModel>.from(
              json['messages'].map((x) => MessageModel.fromJson(x)))
          : [],
    );
  }
}

class MessageModel {
  final int id;
  final String role;
  final String content;
  final String createdAt;

  MessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      role: json['role'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
