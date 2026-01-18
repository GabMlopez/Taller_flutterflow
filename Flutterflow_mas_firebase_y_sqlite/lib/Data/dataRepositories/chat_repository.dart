import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/group_chat.dart';
import '../entities/message.dart';
FirebaseFirestore fireDB = FirebaseFirestore.instance;
class ChatRepository {

  Stream<List<GroupChat>> getChats() {
    return fireDB.collection("project_chats").orderBy("lastMessageTimestamp", descending: true)
    .snapshots().asyncMap(
        (query) async
            {
              List<GroupChat> chats = [];
              for (var chat in query.docs) {
                CollectionReference messageList=fireDB.collection("project_chats").doc(chat.id).collection("messages");
                QuerySnapshot messagesData=await messageList.get();
                List<Message> messages = messagesData.docs.map((message) {
                  return Message(
                    id: message.id,
                    content: message['content'],
                    timestamp: message['timestamp'],
                    user: message['user'],
                    status: message['status'],
                  );
                }).toList();
                chats.add(
                    new GroupChat(id: chat.id,
                        projectId: chat['project'],
                        name: chat['name'],
                        users: List<Map<String, dynamic>>.from(chat['users']),
                        messages: messages,
                        lastMessage: chat['lastMessage'],
                        lastMessageTimestamp: chat['lastMessageTimestamp'],
                        lastMessageSender: chat['lastMessageSender'])
                );
              }
              return chats;
            }
    );
  }

  Future<GroupChat> getChatInfo(String chatId) async{
    GroupChat chat;
    CollectionReference chatList=fireDB.collection("project_chats");
    DocumentSnapshot queryData=await chatList.doc(chatId).get();
    CollectionReference messageList=fireDB.collection("project_chats").doc(queryData.id).collection("messages");
    QuerySnapshot messagesData=await messageList.get();
    List<Message> messages=[];
    for(var message in messagesData.docs)
    {
      messages.add(Message(id: message.id,
          content: message['content'],
          timestamp: message['timestamp'],
          user: message['user'],
          status: message['status']));
    }
    chat=new GroupChat(id: queryData.id,
        projectId: queryData['project'],
        name: queryData['name'],
        users: List<Map<String, dynamic>>.from(queryData['users']),
        messages: messages,
        lastMessage: queryData['lastMessage'],
        lastMessageTimestamp: queryData['lastMessageTimestamp'],
        lastMessageSender: queryData['lastMessageSender']);
    return chat;
  }

  Future<bool> createChat(String projectId) async
  {
    CollectionReference chatCollection=fireDB.collection("project_chats");
    Map<String, dynamic> chatData={
      "project":projectId,
      "name":"Proyecto $projectId",
      "users":[],
      "lastMessage":"",
      "lastMessageTimestamp":"",
      "lastMessageSender":""
    };

    try{
      await chatCollection.add(chatData);
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<bool> updateChat(String chatId, Map<String, dynamic> newChatInfo) async{
    CollectionReference chatCollection=fireDB.collection("project_chats");
    try{
      await chatCollection.doc(chatId).update(newChatInfo);
      return true;
    }
    catch(e){
      return false;
    }
  }
}



