import 'message.dart';
class GroupChat {
  final String id;
  final String projectId;
  final List<Map<String, dynamic>> users;
  final String name;
  final List<Message> messages;
  final String lastMessage;
  final String lastMessageTimestamp;
  final String lastMessageSender;

  GroupChat({required this.id,
    required this.projectId,
    required this.name,
    required this.users,
    required this.messages,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.lastMessageSender});

  String getMemberName(String userId)
  {
    for(var user_data in users)
      {
        if(user_data['uid']==userId)
          {
            return user_data['username'];
          }
      }
      return "";
      }

}