import 'db_repository.dart';

class UserRepository {
  BdRepository dbReference=new BdRepository();

  Future<bool> userLogin(String username, String password) async
  {
    return await dbReference.login(username,password);
  }

  Future<bool> createUser(String username, String password) async
  {
    return await dbReference.addUser(username,password);
  }

}