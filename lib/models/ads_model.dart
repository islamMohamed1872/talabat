class AdModel {
  final int id;
  final int restaurantId;
  final String addType;
  final String title;
  final String description;
  final String? coverImageFullUrl;
  final String? profileImageFullUrl;
  final String? videoAttachmentFullUrl;
  final double averageRating;
  final int reviewsCommentsCount;
  final int active;
  final RestaurantModel restaurant;
  final List<TranslationModel> translations;
  final List<StorageModel> storage;

  AdModel({
    required this.id,
    required this.restaurantId,
    required this.addType,
    required this.title,
    required this.description,
    this.coverImageFullUrl,
    this.profileImageFullUrl,
    this.videoAttachmentFullUrl,
    required this.averageRating,
    required this.reviewsCommentsCount,
    required this.active,
    required this.restaurant,
    required this.translations,
    required this.storage,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      addType: json['add_type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImageFullUrl: json['cover_image_full_url'],
      profileImageFullUrl: json['profile_image_full_url'],
      videoAttachmentFullUrl: json['video_attachment_full_url'],
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCommentsCount: json['reviews_comments_count'] ?? 0,
      active: json['active'] ?? 0,
      restaurant: RestaurantModel.fromJson(json['restaurant']),
      translations: (json['translations'] as List<dynamic>? ?? [])
          .map((e) => TranslationModel.fromJson(e))
          .toList(),
      storage: (json['storage'] as List<dynamic>? ?? [])
          .map((e) => StorageModel.fromJson(e))
          .toList(),
    );
  }
}

class RestaurantModel {
  final int id;
  final String name;
  final String? logoFullUrl;
  final String? coverPhotoFullUrl;
  final String? metaImageFullUrl;
  final String address;
  final String? deliveryTime;

  RestaurantModel({
    required this.id,
    required this.name,
    this.logoFullUrl,
    this.coverPhotoFullUrl,
    this.metaImageFullUrl,
    required this.address,
    this.deliveryTime,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'] ?? '',
      logoFullUrl: json['logo_full_url'],
      coverPhotoFullUrl: json['cover_photo_full_url'],
      metaImageFullUrl: json['meta_image_full_url'],
      address: json['address'] ?? '',
      deliveryTime: json['delivery_time'],
    );
  }
}

class TranslationModel {
  final int id;
  final String locale;
  final String key;
  final String value;

  TranslationModel({
    required this.id,
    required this.locale,
    required this.key,
    required this.value,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      id: json['id'],
      locale: json['locale'] ?? '',
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class StorageModel {
  final int id;
  final String dataType;
  final String dataId;
  final String key;
  final String value;

  StorageModel({
    required this.id,
    required this.dataType,
    required this.dataId,
    required this.key,
    required this.value,
  });

  factory StorageModel.fromJson(Map<String, dynamic> json) {
    return StorageModel(
      id: json['id'],
      dataType: json['data_type'] ?? '',
      dataId: json['data_id'] ?? '',
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }
}
