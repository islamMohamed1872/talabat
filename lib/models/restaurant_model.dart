import 'dart:convert';

/// Main response
class RestaurantResponse {
  final String? filterData;
  final int totalSize;
  final int limit;
  final int offset;
  final List<Restaurant> restaurants;

  RestaurantResponse({
    required this.filterData,
    required this.totalSize,
    required this.limit,
    required this.offset,
    required this.restaurants,
  });

  factory RestaurantResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantResponse(
      filterData: json['filter_data'],
      totalSize: json['total_size'],
      limit: json['limit'],
      offset: json['offset'],
      restaurants: (json['restaurants'] as List)
          .map((e) => Restaurant.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'filter_data': filterData,
    'total_size': totalSize,
    'limit': limit,
    'offset': offset,
    'restaurants': restaurants.map((e) => e.toJson()).toList(),
  };
}

/// Restaurant model
class Restaurant {
  final int id;
  final String? name;
  final String? phone;
  final String? email;
  final String? logo;
  final String? address;
  final String? latitude;
  final String? longitude;
  final int status;
  final int vendorId;
  final bool delivery;
  final bool takeAway;
  final int tax;
  final int zoneId;
  final String? slug;
  final String? deliveryTime;
  final int veg;
  final int nonVeg;

  final List<Food> foods;
  final List<Cuisine> cuisine;
  final List<Translation> translations;
  final List<Storage> storage;

  final double avgRating;
  final int ratingCount;
  final int positiveRating;

  /// Extra fields from response
  final String? logoFullUrl;
  final String? coverPhotoFullUrl;
  final String? metaImageFullUrl;
  final bool? freeDelivery;
  final bool? pickupOnly;

  Restaurant({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.logo,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.status,
    required this.vendorId,
    required this.delivery,
    required this.takeAway,
    required this.tax,
    required this.zoneId,
    required this.slug,
    required this.deliveryTime,
    required this.veg,
    required this.nonVeg,
    required this.foods,
    required this.cuisine,
    required this.translations,
    required this.storage,
    required this.avgRating,
    required this.ratingCount,
    required this.positiveRating,
    required this.logoFullUrl,
    required this.coverPhotoFullUrl,
    this.metaImageFullUrl,
    this.freeDelivery,
    this.pickupOnly
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      logo: json['logo'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      status: json['status'],
      vendorId: json['vendor_id'],
      delivery: json['delivery'],
      takeAway: json['take_away'],
      tax: json['tax'],
      zoneId: json['zone_id'],
      slug: json['slug'],
      deliveryTime: json['delivery_time'],
      veg: json['veg'],
      nonVeg: json['non_veg'],
      foods: (json['foods'] as List).map((e) => Food.fromJson(e)).toList(),
      cuisine: (json['cuisine'] as List).map((e) => Cuisine.fromJson(e)).toList(),
      translations: (json['translations'] as List)
          .map((e) => Translation.fromJson(e))
          .toList(),
      storage:
      (json['storage'] as List).map((e) => Storage.fromJson(e)).toList(),
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      positiveRating: json['positive_rating'] ?? 0,
      logoFullUrl: json['logo_full_url'],
      coverPhotoFullUrl: json['cover_photo_full_url'],
      metaImageFullUrl: json['meta_image_full_url'],
      freeDelivery: json["free_delivery"],
      pickupOnly: json["delivery_type"]!="delivery_only",
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'logo': logo,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'status': status,
    'vendor_id': vendorId,
    'delivery': delivery,
    'take_away': takeAway,
    'tax': tax,
    'zone_id': zoneId,
    'slug': slug,
    'delivery_time': deliveryTime,
    'veg': veg,
    'non_veg': nonVeg,
    'foods': foods.map((e) => e.toJson()).toList(),
    'cuisine': cuisine.map((e) => e.toJson()).toList(),
    'translations': translations.map((e) => e.toJson()).toList(),
    'storage': storage.map((e) => e.toJson()).toList(),
    'avg_rating': avgRating,
    'rating_count': ratingCount,
    'positive_rating': positiveRating,
    'logo_full_url': logoFullUrl,
    'cover_photo_full_url': coverPhotoFullUrl,
    'meta_image_full_url': metaImageFullUrl,
    'delivery_type':pickupOnly!?"delivery_only":"delivery_and_takeaway",
    'free_delivery' : freeDelivery
  };
}

/// Food model
class Food {
  final int id;
  final String? name;
  final String? imageFullUrl;
  final List<Storage> storage;
  final List<Translation> translations;

  Food({
    required this.id,
    required this.name,
    required this.imageFullUrl,
    required this.storage,
    required this.translations,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      imageFullUrl: json['image_full_url'],
      storage:
      (json['storage'] as List).map((e) => Storage.fromJson(e)).toList(),
      translations: (json['translations'] as List)
          .map((e) => Translation.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image_full_url': imageFullUrl,
    'storage': storage.map((e) => e.toJson()).toList(),
    'translations': translations.map((e) => e.toJson()).toList(),
  };
}

/// Cuisine model
class Cuisine {
  final int id;
  final String? name;
  final String? imageFullUrl;
  final List<Translation> translations;
  final List<Storage> storage;

  Cuisine({
    required this.id,
    required this.name,
    required this.imageFullUrl,
    required this.translations,
    required this.storage,
  });

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      id: json['id'],
      name: json['name'],
      imageFullUrl: json['image_full_url'],
      translations: (json['translations'] as List)
          .map((e) => Translation.fromJson(e))
          .toList(),
      storage:
      (json['storage'] as List).map((e) => Storage.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image_full_url': imageFullUrl,
    'translations': translations.map((e) => e.toJson()).toList(),
    'storage': storage.map((e) => e.toJson()).toList(),
  };
}

/// Generic Translation model
class Translation {
  final int id;
  final String? locale;
  final String? key;
  final String? value;

  Translation({
    required this.id,
    required this.locale,
    required this.key,
    required this.value,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'],
      locale: json['locale'],
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'locale': locale,
    'key': key,
    'value': value,
  };
}

/// Generic Storage model
class Storage {
  final int id;
  final String? dataType;
  final String? dataId;
  final String? key;
  final String? value;

  Storage({
    required this.id,
    required this.dataType,
    required this.dataId,
    required this.key,
    required this.value,
  });

  factory Storage.fromJson(Map<String, dynamic> json) {
    return Storage(
      id: json['id'],
      dataType: json['data_type'],
      dataId: json['data_id'],
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'data_type': dataType,
    'data_id': dataId,
    'key': key,
    'value': value,
  };
}
