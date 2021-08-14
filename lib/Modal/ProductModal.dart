import 'dart:async';

class ProductData {
  // Dummy data class not implemented yet !
   var data=[
     {
       "id":1,
       "product":1,
       "image":"",
       "price":"70"
     },
     {
       "id":1,
       "product":2,
       "image":"",
       "price":"80"
     },
     {
       "id":1,
       "product":3,
       "image":"",
       "price":"70"
     },
     {
       "id":1,
       "product":4,
       "image":"",
       "price":"80"
     }
   ];
   Future<List<ProductModal>>getData() async{
    final response= await Future.delayed(Duration(seconds: 1));
    return data.map((json) => ProductModal.fromJson(json)).toList();
  }
   Future<List<ServiceModal>>getServiceData() async{
     final response= await Future.delayed(Duration(seconds: 1));
     return data.map((json) => ServiceModal.fromJson(json)).toList();
   }

}
class ProductModal {
  int ? id;
  int ? product;
  String ? image;
  String ? price;

  ProductModal({this.id, this.product, this.image, this.price});

  factory ProductModal.fromJson(Map<String, dynamic> json) {
   return ProductModal(id :json['id'],
    product :json['product'],
    image :json['image'],
    price : json['price']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product'] = this.product;
    data['image'] = this.image;
    data['price'] = this.price;
    return data;
  }
}

class ServiceModal {
  int ? id;
  int ? product;
  String ? image;
  String ? price;

  ServiceModal({this.id, this.product, this.image, this.price});

  factory ServiceModal.fromJson(Map<String, dynamic> json) {
    return ServiceModal(id :json['id'],
        product :json['product'],
        image :json['image'],
        price : json['price']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product'] = this.product;
    data['image'] = this.image;
    data['price'] = this.price;
    return data;
  }
}