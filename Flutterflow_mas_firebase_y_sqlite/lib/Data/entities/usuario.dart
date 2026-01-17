class UserModel {
  final int id;
  final String usuario;

  UserModel({
    required this.id,
    required this.usuario,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      usuario: json['usuario'],
    );
  }
}
