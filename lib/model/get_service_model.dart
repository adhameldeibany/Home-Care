class GetServiceModel {
  final int cost;
  final String title;
  final String id;
  final String status;
  final String address;
  final String serviceID;

  GetServiceModel({
    required this.cost,
    required this.title,
    required this.id,
    required this.status,
    required this.address,
    required this.serviceID
  });

  factory GetServiceModel.fromMap(Map<String, dynamic> map) {
    return GetServiceModel(
      serviceID: map['serviceID'],
      address: map['address'],
      status:  map['status'],
      cost: map['cost'],
      title: map['title'],
      id: map['id'],
    );
  }
}