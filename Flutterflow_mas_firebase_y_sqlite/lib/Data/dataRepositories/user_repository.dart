import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/chat_user.dart';
import 'package:firebase_core/firebase_core.dart';
FirebaseFirestore fireDB=FirebaseFirestore.instance;
class UserRepository {

  Future<ChatUser> getUserByName(String username) async{
    ChatUser user;
    CollectionReference userList=fireDB.collection("users");
    QuerySnapshot queryData=await userList.where("username", isEqualTo: username).get();
    user = new ChatUser(id: queryData.docs[0].id, username: queryData.docs[0]['username'], password: queryData.docs[0]['password']);
    return user;
  }

  Future<ChatUser> getUserById(String id) async {
    ChatUser user;
    CollectionReference userList = fireDB.collection("users");
    DocumentSnapshot queryData = await userList.doc(id).get();
    user = new ChatUser(id: queryData.id,
        username: queryData['username'],
        password: queryData['password']);
    return user;
  }



  Future<List<ChatUser>> getUsers() async {
    List<ChatUser> users = [];
    CollectionReference userList = fireDB.collection("users");
    QuerySnapshot query = await userList.get();
    for (var user in query.docs) {
      users.add(new ChatUser(id: user.id, username: user['username'], password: user['password']));
    }
    return users;
  }

  Future<bool> addUser(String username, String password) async{
    CollectionReference userCollection=fireDB.collection("users");
    Map<String, dynamic> userData={
      "username":username,
      "password":password
    };
    try{
      await userCollection.add(userData);
      return true;
    }
    catch(e){
      return false;
    }
  }
  Future<bool> updateUser(ChatUser updatedUser) async{
    CollectionReference userCollection=fireDB.collection("users");
    Map<String, dynamic> userData={
      "username":updatedUser.username,
      "password":updatedUser.password
    };
    try{
      await userCollection.doc(updatedUser.id).update(userData);
      return true;
    }
    catch(e){
      return false;
    }
  }
  Future<bool> deleteUser(String id) async{
    CollectionReference userCollection=fireDB.collection("users");
    try{
      await userCollection.doc(id).delete();
      return true;
    }
    catch(e){
      return false;
    }
  }

}