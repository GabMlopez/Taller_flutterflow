import '../dataRepositories/chat_repository.dart';
import '../entities/group_chat.dart';
import '../entities/chat_user.dart';
import '../entities/message.dart';
import '../dataRepositories/message_repository.dart';
import '../dataServices/user_service.dart';
class ChatService {
  ChatRepository repository= ChatRepository();
  MessageRepository messageRepo = MessageRepository();
  UserService _userService = UserService();

  Stream<List<GroupChat>> getChats() {
    return repository.getChats();
  }

  Future<GroupChat> getChatInfo(String chatId) async {
    return await repository.getChatInfo(chatId);
  }

  Future<bool> createChat(String projectId) async
  {
    return await repository.createChat(projectId);
  }

  Future<bool> addUserToChat(String chatId, String userId) async
  {
    GroupChat chat = await getChatInfo(chatId);
    List <Map<String, dynamic>> chatMembers = List<Map<String, dynamic>>.from(chat.users);
    ChatUser user = await _userService.getUserInfoById(userId);
    if(user != null)
    {
      try {
        chatMembers.add({
          "uid" : user.id,
          "username":user.username
        });
        await repository.updateChat(chatId, {"users":chatMembers});
        return true;
      }catch(e)
      {
        return false;
      }
    }
    else
    {
      return false;
    }

  }

  Future<void> updateLastMessage(String chatId) async
  {
    GroupChat chat = await getChatInfo(chatId);
    List<Message> chatMessages = chat.messages;
    chatMessages.sort((a,b) => a.timestamp.compareTo(b.timestamp));
    if(chatMessages.isNotEmpty)
    {
      Message lastMessage = chatMessages.last;
      await repository.updateChat(chatId, {
        "lastMessage":lastMessage.content,
        "lastMessageTimestamp":lastMessage.timestamp,
        "lastMessageSender":lastMessage.user
      });
    }
  }


  Stream<List<Message>> getMessages(String chatId) {
    return  messageRepo.getMessages(chatId);
  }
}

