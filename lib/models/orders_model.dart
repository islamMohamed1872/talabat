import 'dart:convert';

/// Root response
class OrdersResponse {
  final int totalSize;
  final int limit;
  final int offset;
  final List<OrderModel> orders;

  OrdersResponse({
    required this.totalSize,
    required this.limit,
    required this.offset,
    required this.orders,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      totalSize: json['total_size'],
      limit: int.tryParse(json['limit'].toString()) ?? 0,
      offset: int.tryParse(json['offset'].toString()) ?? 0,
      orders: (json['orders'] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList(),
    );
  }
}


/// Order model
class OrderModel {
  final int id;
  final int userId;
  final double orderAmount;
  final String paymentStatus;
  final String orderStatus;
  final String orderTime;
  final String deliveryTime;
  final String paymentMethod;
  final String? scheduleAt;
  final String? otp;
  final DeliveryAddress? deliveryAddress;
  final Restaurant? restaurant;
  final List<OrderItem> items;
  final List<OrderDetail> details;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.paymentMethod,
    this.scheduleAt,
    this.otp,
    this.deliveryAddress,
    required this.orderTime,
    required this.deliveryTime,
    this.restaurant,
    required this.items,
    required this.details,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      deliveryTime: json['updated_at'],
      orderTime: json['order_time'],
      userId: json['user_id'],
      orderAmount: (json['order_amount'] as num).toDouble(),
      paymentStatus: json['payment_status'],
      orderStatus: json['order_status'],
      paymentMethod: json['payment_method'],
      scheduleAt: json['schedule_at'],
      otp: json['otp'],
      deliveryAddress: json['delivery_address'] != null
          ? DeliveryAddress.fromJson(json['delivery_address'])
          : null,
      restaurant: json['restaurant'] != null
          ? Restaurant.fromJson(json['restaurant'])
          : null,
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      details: (json['details'] as List)
          .map((e) => OrderDetail.fromJson(e))
          .toList(),
    );
  }
}

/// Delivery address
class DeliveryAddress {
  final String contactPersonName;
  final String contactPersonNumber;
  final String? contactPersonEmail;
  final String addressType;
  final String address;
  final String? floor;
  final String? road;
  final String? house;
  final String longitude;
  final String latitude;

  DeliveryAddress({
    required this.contactPersonName,
    required this.contactPersonNumber,
    this.contactPersonEmail,
    required this.addressType,
    required this.address,
    this.floor,
    this.road,
    this.house,
    required this.longitude,
    required this.latitude,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      contactPersonName: json['contact_person_name'],
      contactPersonNumber: json['contact_person_number'],
      contactPersonEmail: json['contact_person_email'],
      addressType: json['address_type'],
      address: json['address'],
      floor: json['floor'],
      road: json['road'],
      house: json['house'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}


/// Restaurant model
class Restaurant {
  final int id;
  final String name;
  final String deliveryTime;
  final String? logoFullUrl;
  final String? coverPhotoFullUrl;
  final double tax;
  final List<Food> foods;
  final List<Cuisine> cuisines;
  final List<Schedule> schedules;

  Restaurant({
    required this.id,
    required this.name,
    required this.deliveryTime,
    this.logoFullUrl,
    this.coverPhotoFullUrl,
    required this.tax,
    required this.foods,
    required this.cuisines,
    required this.schedules,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      deliveryTime: json['delivery_time'],
      logoFullUrl: json['logo_full_url'],
      coverPhotoFullUrl: json['cover_photo_full_url'],
      tax: (json['tax'] as num).toDouble(),
      foods: (json['foods'] as List)
          .map((e) => Food.fromJson(e))
          .toList(),
      cuisines: (json['cuisine'] as List)
          .map((e) => Cuisine.fromJson(e))
          .toList(),
      schedules: (json['schedules'] as List)
          .map((e) => Schedule.fromJson(e))
          .toList(),
    );
  }
}

/// Food model
class Food {
  final int id;
  final String name;
  final String image;
  final String? imageFullUrl;
  final List<Translation> translations;

  Food({
    required this.id,
    required this.name,
    required this.image,
    this.imageFullUrl,
    required this.translations,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      imageFullUrl: json['image_full_url'],
      translations: (json['translations'] as List)
          .map((e) => Translation.fromJson(e))
          .toList(),
    );
  }
}

/// Cuisine model
class Cuisine {
  final int id;
  final String name;
  final String? imageFullUrl;
  final List<Translation> translations;

  Cuisine({
    required this.id,
    required this.name,
    this.imageFullUrl,
    required this.translations,
  });

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      id: json['id'],
      name: json['name'],
      imageFullUrl: json['image_full_url'],
      translations: (json['translations'] as List)
          .map((e) => Translation.fromJson(e))
          .toList(),
    );
  }
}

/// Schedule model
class Schedule {
  final int id;
  final int day;
  final String openingTime;
  final String closingTime;

  Schedule({
    required this.id,
    required this.day,
    required this.openingTime,
    required this.closingTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      day: json['day'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
    );
  }
}

/// Translation model (for food/restaurant/cuisine names, descriptions, etc.)
class Translation {
  final int id;
  final String locale;
  final String key;
  final String value;

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
}

class OrderItem {
  final String name;
  final double price;
  final String? image;

  OrderItem({
    required this.name,
    required this.price,
    this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }
}

class OrderDetail {
  final int id;
  final int orderId;
  final int foodId;
  final double price;
  final int quantity;
  final String foodDetails; // can later be parsed into Food object

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.foodId,
    required this.price,
    required this.quantity,
    required this.foodDetails,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      orderId: json['order_id'],
      foodId: json['food_id'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      foodDetails: json['food_details'],
    );
  }
}
