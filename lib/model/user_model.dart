class UserModel{
  String age;
  bool ban;
  String email;
  String id;
  bool online;
  String photo;
  String role;
  String name;
  String phone;
  bool approved;
  String gender;
  String description;
  String address;
  List<String>chornic;

  UserModel({
    required this.age,
    required this.ban,
    required this.email,
    required this.id,
    required this.online,
    required this.photo,
    required this.role,
    required this.name,
    required this.phone,
    required this.approved,
    required this.gender,
    required this.description,
    required this.address,
    required this.chornic,
  });

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'ban': this.ban,
      'email': this.email,
      'id': this.id,
      'online': this.online,
      'photo': this.photo,
      'role': this.role,
      'name': this.name,
      'phone': this.phone,
      'approved': this.approved,
      'gender': this.gender,
      'description': this.description,
      'address': this.address,
      'chornic': this.chornic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      age: map['age'] as String,
      ban: map['ban'] as bool,
      email: map['email'] as String,
      id: map['id'] as String,
      online: map['online'] as bool,
      photo: map['photo'] as String,
      role: map['role'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      approved: map['approved'] as bool,
      gender: map['gender'] as String,
      description: map['description'] as String,
      address: map['address'] as String,
      chornic: List<String>.from(map['chornic'].map((x) => x)),
    );
  }
}