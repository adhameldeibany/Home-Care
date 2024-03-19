class UserInfo{
  String userName;
  String email;
  String phone;
  String address;

  UserInfo({
    required this.userName,
    required this.email,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': this.userName,
      'email': this.email,
      'phone': this.phone,
      'address': this.address,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      userName: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
    );
  }
}