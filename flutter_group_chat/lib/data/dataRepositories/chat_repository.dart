import 'db_repository.dart';
import '../domain/models/group_chat.dart';
class ChatRepository {
  BdRepository dbReference = new BdRepository();

  Future<bool> createChat(String chatName) async {
    return await dbReference.createChat(chatName);
  }

  Future<GroupChat> getChatInfo(String chatId) async {
    return await dbReference.getChatInfo(chatId);
  }


}