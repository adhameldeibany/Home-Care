class ServiceModel {
  final int cost;
  final String title;
  final String id;
  final String homecareID;

  ServiceModel({
    required this.cost,
    required this.title,
    required this.id,
    required this.homecareID,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      cost: map['cost'],
      title: map['title'],
      id: map['id'],
      homecareID: map['homecareID'],
    );
  }
}
