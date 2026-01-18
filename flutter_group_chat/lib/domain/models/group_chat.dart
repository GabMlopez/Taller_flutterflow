import '../../domain/models/message.dart';
import 'message.dart';
import 'user.dart';

class GroupChat {
  final String id;
  final List<User> users;
  final String name;
  final List<Message> messages;
  final String lastMessage;
  final String lastMessageTimestamp;
  final String lastMessageSender;

  GroupChat({required this.id,
    required this.name,
    required this.users,
    required this.messages,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.lastMessageSender});

  factory GroupChat.fromJson(Map<String, dynamic> json) {
    return GroupChat(
      id: json['id'],
      name: json['name'],
      users: (json['users'] as List).map((user) => User.fromJson(user)).toList(),
      messages: (json['messages'] as List).map((message) => Message.fromJson(message)).toList(),
      lastMessage: json['lastMessage'],
      lastMessageTimestamp: json['lastMessageTimestamp'],
      lastMessageSender: json['lastMessageSender'],
    );
  }
}