class Contact {
  int id;
  String name;
  String phone;
  String image;
  String email;
  String contactEmail;
  String address;

  Contact(this.id, this.name, this.phone, this.email,
      this.contactEmail, this.image, this.address);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'image': image,
      'email': email,
      'ContactEmail': contactEmail,
      'address': address,
    };
    return map;
  }

  Contact.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    phone = map['phone'];
    image = map['image'];
    email = map['email'];
    contactEmail = map['ContactEmail'];
    address = map['address'];
  }
}