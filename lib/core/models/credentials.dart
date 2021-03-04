class LoginCredentials {
  int id;
  String email;
  String password;
  LoginCredentials(this.id, this.email, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'email' : email,
      'password': password,
    };
    return map;
  }

  LoginCredentials.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    email = map['email'];
    password = map['password'];
  }
}