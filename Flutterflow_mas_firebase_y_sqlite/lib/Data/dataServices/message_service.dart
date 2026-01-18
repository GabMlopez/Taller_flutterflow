import '../dataRepositories/message_repository.dart';
import 'chat_service.dart';
class MessageService {
  MessageRepository repository= MessageRepository();
  ChatService chatService = ChatService();
  Future<bool> sendMessage(String newMessage, String chatId, String userId) async{
    String timestamp=DateTime.now().toString();
    bool sent = await repository.sendMessage(newMessage, chatId, userId, timestamp);
    if(sent)
      {
        chatService.updateLastMessage(chatId);
      }
    return sent;
  }

}