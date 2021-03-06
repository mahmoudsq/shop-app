class FavoritesModel
{
  late final bool status;
  String? message;
  Data? data;

  FavoritesModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  late final int currentPage;
  late final List<FavoritesData> data;
  late final String firstPageUrl;
  late final int from;
  late final int lastPage;
  late final String lastPageUrl;
  String? nextPageUrl;
  late final String path;
  late final int perPage;
  String? prevPageUrl;
  late final int to;
  late final int total;

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data =  [];
      json['data'].forEach((v) {
        data.add(FavoritesData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }
}

class FavoritesData {
  late final int id;
  Product? product;

  FavoritesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
    json['product'] != null ?  Product.fromJson(json['product']) : null;
  }
}

class Product {
  late final int id;
  late final dynamic price;
  late final dynamic oldPrice;
  late final int discount;
  late final String image;
  late final String name;
  late final String description;

  Product(
      {required this.id,
        this.price,
        this.oldPrice,
        required this.discount,
        required this.image,
        required this.name,
        required this.description});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['old_price'] = oldPrice;
    data['discount'] = discount;
    data['image'] = image;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
