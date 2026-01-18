import '../dataRepositories/user_repository.dart';
import '../entities/chat_user.dart';
class UserService {
  UserRepository repository= UserRepository();
  Future<ChatUser> getUserInfoByName(String username) async{
    return await repository.getUserByName(username);
  }

  Future<ChatUser> getUserInfoById(String id) async{
    return await repository.getUserById(id);
  }


  Future<List<ChatUser>> getUsers() async {
    return await repository.getUsers();
  }

  Future<bool> addUser(String username, String password) async{
    return await repository.addUser(username, password);
  }
  Future<bool> updateUser(ChatUser updatedUser) async{
    return await repository.updateUser(updatedUser);
  }

  Future<bool> deleteUser(String id) async{
    return await repository.deleteUser(id);
  }


  Future<bool> login(String username, String password) async{
    List<ChatUser> users=await getUsers();
    bool validated=false;
    for(var user in users)
      {
        if(user.username==username && user.password==password)
        {
          validated=true;
        }
      }
      return validated;
    }

}