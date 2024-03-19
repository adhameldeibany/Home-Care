
class OrderModelData{

  String idProduct;
  int quantity;
  String homecareID;
  String image;

  OrderModelData({
    required this.idProduct,
    required this.quantity,
    required this.homecareID,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'idProduct': this.idProduct,
      'quantity': this.quantity,
      'homecareID': this.homecareID,
      'image': this.image,
    };
  }

  factory OrderModelData.fromMap(Map<String, dynamic> map) {
    return OrderModelData(
      idProduct: map['idProduct'] as String,
      quantity: map['quantity'] as int,
      homecareID: map['homecareID'] as String,
      image: map['image'] as String,
    );
  }
}