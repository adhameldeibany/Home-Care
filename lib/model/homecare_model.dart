class HomecareModel{
  String name;
  String email;
  String id;
  String phone;
  String photo;
  String address;
  String description;
  bool online;
  bool ban;

  HomecareModel({
    required this.name,
    required this.email,
    required this.id,
    required this.phone,
    required this.photo,
    required this.address,
    required this.description,
    required this.online,
    required this.ban,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'id': this.id,
      'phone': this.phone,
      'photo': this.photo,
      'address': this.address,
      'description': this.description,
      'online': this.online,
      'ban': this.ban,
    };
  }

  factory HomecareModel.fromMap(Map<String, dynamic> map) {
    return HomecareModel(
      name: map['name'] as String,
      email: map['email'] as String,
      id: map['id'] as String,
      phone: map['phone'] as String,
      photo: map['photo'] as String,
      address: map['address'] as String,
      description: map['description'] as String,
      online: map['online'] as bool,
      ban: map['ban'] as bool,
    );
  }
}