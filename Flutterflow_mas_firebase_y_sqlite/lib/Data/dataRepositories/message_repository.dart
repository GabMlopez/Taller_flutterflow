import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/message.dart';
FirebaseFirestore fireDB=FirebaseFirestore.instance;
class MessageRepository {

  Future<bool> sendMessage(String newMessage, String chatId, String userId, String timestamp) async{
    CollectionReference chatList=fireDB.collection("project_chats").doc(chatId).collection("messages");
    try{
      await chatList.add({
        "user":userId,
        "content":newMessage,
        "timestamp":timestamp,
        "status":"not read"
      });
      return true;
    }
    catch(e)
    {
      return false;
    }
  }

  Stream<List<Message>> getMessages(String chatId) {
    return fireDB.collection("project_chats").doc(chatId).collection("messages")
        .orderBy("timestamp", descending: false).snapshots().map(
            (querySnapshot)
        {
          return querySnapshot.docs.map((doc)
          {
            return Message(
                id: doc.id,
                user: doc["user"],
                content: doc["content"],
                timestamp: doc["timestamp"],
                status: doc["status"]
            );
          }).toList();
        }
    );
  }
}