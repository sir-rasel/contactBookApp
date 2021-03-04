class User {
  int id;
  String name;
  String phone;
  String email;
  String address;
  User(this.id, this.name, this.phone, this.email, this.address);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    phone = map['phone'];
    email = map['email'];
    address = map['address'];
  }
}