// ======================
// Food Models
// ======================

class SearchedFood {
  final int id;
  final String name;
  final String image;
  final String imageFullUrl;
  final List<FoodStorage> storage;
  final List<FoodTranslation> translations;

  SearchedFood({
    required this.id,
    required this.name,
    required this.image,
    required this.imageFullUrl,
    required this.storage,
    required this.translations,
  });

  factory SearchedFood.fromJson(Map<String, dynamic> json) {
    return SearchedFood(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
      imageFullUrl: json['image_full_url'] ?? '',
      storage: (json['storage'] as List<dynamic>)
          .map((e) => FoodStorage.fromJson(e))
          .toList(),
      translations: (json['translations'] as List<dynamic>)
          .map((e) => FoodTranslation.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "image_full_url": imageFullUrl,
    "storage": storage.map((e) => e.toJson()).toList(),
    "translations": translations.map((e) => e.toJson()).toList(),
  };
}

class FoodStorage {
  final int id;
  final String dataType;
  final String dataId;
  final String key;
  final String value;
  final String createdAt;
  final String updatedAt;

  FoodStorage({
    required this.id,
    required this.dataType,
    required this.dataId,
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodStorage.fromJson(Map<String, dynamic> json) {
    return FoodStorage(
      id: json['id'],
      dataType: json['data_type'],
      dataId: json['data_id'],
      key: json['key'],
      value: json['value'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "data_type": dataType,
    "data_id": dataId,
    "key": key,
    "value": value,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class FoodTranslation {
  final int id;
  final String translationableType;
  final int translationableId;
  final String locale;
  final String key;
  final String value;
  final String? createdAt;
  final String? updatedAt;

  FoodTranslation({
    required this.id,
    required this.translationableType,
    required this.translationableId,
    required this.locale,
    required this.key,
    required this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory FoodTranslation.fromJson(Map<String, dynamic> json) {
    return FoodTranslation(
      id: json['id'],
      translationableType: json['translationable_type'],
      translationableId: json['translationable_id'],
      locale: json['locale'],
      key: json['key'],
      value: json['value'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "translationable_type": translationableType,
    "translationable_id": translationableId,
    "locale": locale,
    "key": key,
    "value": value,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

// ======================
// Restaurant Models
// ======================

class SearchedRestaurant {
  final int id;
  final String name;
  final String logo;
  final bool gstStatus;
  final String gstCode;
  final bool freeDeliveryDistanceStatus;
  final String freeDeliveryDistanceValue;
  final String logoFullUrl;
  final String? coverPhotoFullUrl;
  final String? metaImageFullUrl;
  final String? tinCertificateImageFullUrl;
  final String deliveryType;
  final String deliveryFeeType;
  final RestaurantConfig restaurantConfig;
  final List<RestaurantTranslation> translations;
  final List<RestaurantStorage> storage;

  SearchedRestaurant({
    required this.id,
    required this.name,
    required this.logo,
    required this.gstStatus,
    required this.gstCode,
    required this.freeDeliveryDistanceStatus,
    required this.freeDeliveryDistanceValue,
    required this.logoFullUrl,
    this.coverPhotoFullUrl,
    this.metaImageFullUrl,
    this.tinCertificateImageFullUrl,
    required this.deliveryType,
    required this.deliveryFeeType,
    required this.restaurantConfig,
    required this.translations,
    required this.storage,
  });

  factory SearchedRestaurant.fromJson(Map<String, dynamic> json) {
    return SearchedRestaurant(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      gstStatus: json['gst_status'],
      gstCode: json['gst_code'],
      freeDeliveryDistanceStatus: json['free_delivery_distance_status'],
      freeDeliveryDistanceValue: json['free_delivery_distance_value'],
      logoFullUrl: json['logo_full_url'],
      coverPhotoFullUrl: json['cover_photo_full_url'],
      metaImageFullUrl: json['meta_image_full_url'],
      tinCertificateImageFullUrl: json['tin_certificate_image_full_url'],
      deliveryType: json['delivery_type'],
      deliveryFeeType: json['delivery_fee_type'],
      restaurantConfig: RestaurantConfig.fromJson(json['restaurant_config']),
      translations: (json['translations'] as List<dynamic>)
          .map((e) => RestaurantTranslation.fromJson(e))
          .toList(),
      storage: (json['storage'] as List<dynamic>)
          .map((e) => RestaurantStorage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo": logo,
    "gst_status": gstStatus,
    "gst_code": gstCode,
    "free_delivery_distance_status": freeDeliveryDistanceStatus,
    "free_delivery_distance_value": freeDeliveryDistanceValue,
    "logo_full_url": logoFullUrl,
    "cover_photo_full_url": coverPhotoFullUrl,
    "meta_image_full_url": metaImageFullUrl,
    "tin_certificate_image_full_url": tinCertificateImageFullUrl,
    "delivery_type": deliveryType,
    "delivery_fee_type": deliveryFeeType,
    "restaurant_config": restaurantConfig.toJson(),
    "translations": translations.map((e) => e.toJson()).toList(),
    "storage": storage.map((e) => e.toJson()).toList(),
  };
}

class RestaurantConfig {
  final int id;
  final int restaurantId;
  final bool instantOrder;
  final bool customerDateOrderStatus;
  final int customerOrderDate;
  final String createdAt;
  final String updatedAt;
  final int halalTagStatus;
  final bool extraPackagingStatus;
  final bool isExtraPackagingActive;
  final dynamic extraPackagingAmount;
  final int dineIn;
  final int scheduleAdvanceDineInBookingDuration;
  final String scheduleAdvanceDineInBookingDurationTimeFormat;

  RestaurantConfig({
    required this.id,
    required this.restaurantId,
    required this.instantOrder,
    required this.customerDateOrderStatus,
    required this.customerOrderDate,
    required this.createdAt,
    required this.updatedAt,
    required this.halalTagStatus,
    required this.extraPackagingStatus,
    required this.isExtraPackagingActive,
    this.extraPackagingAmount,
    required this.dineIn,
    required this.scheduleAdvanceDineInBookingDuration,
    required this.scheduleAdvanceDineInBookingDurationTimeFormat,
  });

  factory RestaurantConfig.fromJson(Map<String, dynamic> json) {
    return RestaurantConfig(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      instantOrder: json['instant_order'],
      customerDateOrderStatus: json['customer_date_order_sratus'],
      customerOrderDate: json['customer_order_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      halalTagStatus: json['halal_tag_status'],
      extraPackagingStatus: json['extra_packaging_status'],
      isExtraPackagingActive: json['is_extra_packaging_active'],
      extraPackagingAmount: json['extra_packaging_amount'],
      dineIn: json['dine_in'],
      scheduleAdvanceDineInBookingDuration:
      json['schedule_advance_dine_in_booking_duration'],
      scheduleAdvanceDineInBookingDurationTimeFormat:
      json['schedule_advance_dine_in_booking_duration_time_format'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "instant_order": instantOrder,
    "customer_date_order_sratus": customerDateOrderStatus,
    "customer_order_date": customerOrderDate,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "halal_tag_status": halalTagStatus,
    "extra_packaging_status": extraPackagingStatus,
    "is_extra_packaging_active": isExtraPackagingActive,
    "extra_packaging_amount": extraPackagingAmount,
    "dine_in": dineIn,
    "schedule_advance_dine_in_booking_duration":
    scheduleAdvanceDineInBookingDuration,
    "schedule_advance_dine_in_booking_duration_time_format":
    scheduleAdvanceDineInBookingDurationTimeFormat,
  };
}

class RestaurantTranslation {
  final int id;
  final String translationableType;
  final int translationableId;
  final String locale;
  final String key;
  final String value;
  final String? createdAt;
  final String? updatedAt;

  RestaurantTranslation({
    required this.id,
    required this.translationableType,
    required this.translationableId,
    required this.locale,
    required this.key,
    required this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory RestaurantTranslation.fromJson(Map<String, dynamic> json) {
    return RestaurantTranslation(
      id: json['id'],
      translationableType: json['translationable_type'],
      translationableId: json['translationable_id'],
      locale: json['locale'],
      key: json['key'],
      value: json['value'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "translationable_type": translationableType,
    "translationable_id": translationableId,
    "locale": locale,
    "key": key,
    "value": value,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class RestaurantStorage {
  final int id;
  final String dataType;
  final String dataId;
  final String key;
  final String value;
  final String createdAt;
  final String updatedAt;

  RestaurantStorage({
    required this.id,
    required this.dataType,
    required this.dataId,
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestaurantStorage.fromJson(Map<String, dynamic> json) {
    return RestaurantStorage(
      id: json['id'],
      dataType: json['data_type'],
      dataId: json['data_id'],
      key: json['key'],
      value: json['value'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "data_type": dataType,
    "data_id": dataId,
    "key": key,
    "value": value,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
