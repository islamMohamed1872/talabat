class RestaurantDetailsModel {
  final int id;
  final String? bannerImage;
  final String? logo;
  final String? name;
  final List<Category> category;
  final List<MenuItem> menu;
  final Offers offers;
  final String? deliveryType;
  final String? deliveryFeeType;
  final Pagination pagination;

  RestaurantDetailsModel({
    required this.id,
    required this.bannerImage,
    required this.logo,
    required this.name,
    required this.category,
    required this.menu,
    required this.offers,
    required this.deliveryType,
    required this.deliveryFeeType,
    required this.pagination,
  });

  factory RestaurantDetailsModel.fromJson(Map<String, dynamic> json) {
    print(json);
    print(json['longitude']);
    return RestaurantDetailsModel(
      id: json['id'],
      bannerImage: json['banner_image'],
      logo: json['logo'],
      name: json['name'],
      category: (json['category'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
      menu: (json['menu'] as List).map((e) => MenuItem.fromJson(e)).toList(),
      offers: Offers.fromJson(json['offers']),
      deliveryType: json['delivery_type'],
      deliveryFeeType: json['delivery_fee_type'],
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'banner_image': bannerImage,
      'logo': logo,
      'name': name,
      'category': category.map((e) => e.toJson()).toList(),
      'menu': menu.map((e) => e.toJson()).toList(),
      'offers': offers.toJson(),
      'delivery_type': deliveryType,
      'delivery_fee_type': deliveryFeeType,
      'pagination': pagination.toJson(),
    };
  }
}

class Category {
  final int id;
  final String? name;
  final String? slug;

  Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}

class MenuItem {
  final int id;
  final String? name;
  final String? image;
  final String? imageFullUrl;
  final double price;
  final String? type;

  MenuItem({
    required this.id,
    required this.name,
    required this.image,
    required this.imageFullUrl,
    required this.price,
    required this.type,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      imageFullUrl: json['image_full_url'],
      price: (json['price'] as num).toDouble(),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'image_full_url': imageFullUrl,
      'price': price,
      'type': type,
    };
  }
}

class Offers {
  final dynamic discount;
  final List<dynamic> coupons;

  Offers({
    required this.discount,
    required this.coupons,
  });

  factory Offers.fromJson(Map<String, dynamic> json) {
    return Offers(
      discount: json['discount'],
      coupons: List<dynamic>.from(json['coupons']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discount': discount,
      'coupons': coupons,
    };
  }
}

class Pagination {
  final int limit;
  final int page;
  final int count;

  Pagination({
    required this.limit,
    required this.page,
    required this.count,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      limit: json['limit'],
      page: json['page'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'page': page,
      'count': count,
    };
  }
}
