class DetailsModelHomecare{
  final bool approved;
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String address;

  const DetailsModelHomecare({
    required this.approved,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'approved': this.approved,
      'id': this.id,
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'photo': this.photo,
      'address': this.address,
    };
  }

  factory DetailsModelHomecare.fromMap(Map<String, dynamic> map) {
    return DetailsModelHomecare(
      approved: map['approved'] as bool,
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      photo: map['photo'] as String,
      address: map['address'] as String,
    );
  }
}
