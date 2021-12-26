class HomeModel
{
  late final bool status;
  HomeDataModel? data;

  HomeModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel
{
  List<BannerModel>? banners = [];
  List<ProductModel>? products = [];

  HomeDataModel.fromJson(Map<String, dynamic> json)
  {
    json['banners'].forEach((element)
    {
      banners!.add(BannerModel.fromJson(element));
    });

    json['products'].forEach((element)
    {
      products!.add(ProductModel.fromJson(element));
    });
  }
}

class BannerModel
{
 late final int id;
 late final String image;

  BannerModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    image = json['image'];
  }
}

class ProductModel
{
  late final int id;
  late final dynamic price;
  late final dynamic oldPrice;
  dynamic discount;
  late final String image;
  late final String name;
  late final bool inFavorites;
  late final bool inCart;

  ProductModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}