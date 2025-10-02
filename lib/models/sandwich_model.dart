class SandwichModel {
  final int id;
  final String name;
  final String description;
  final String? image;
  final int categoryId;
  final List<CategoryId> categoryIds;
  final List<Variation> variations;
  final List<AddOn> addOns;
  final double price;
  final double tax;
  final String taxType;
  final double discount;
  final String discountType;
  final String availableTimeStarts;
  final String availableTimeEnds;
  final int veg;
  final int status;
  final int restaurantId;
  final String? imageFullUrl;
  final String restaurantName;
  final List<Cuisine> cuisines;

  SandwichModel({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.categoryId,
    required this.categoryIds,
    required this.variations,
    required this.addOns,
    required this.price,
    required this.tax,
    required this.taxType,
    required this.discount,
    required this.discountType,
    required this.availableTimeStarts,
    required this.availableTimeEnds,
    required this.veg,
    required this.status,
    required this.restaurantId,
    this.imageFullUrl,
    required this.restaurantName,
    required this.cuisines,
  });

  factory SandwichModel.fromJson(Map<String, dynamic> json) {
    return SandwichModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      categoryId: json['category_id'],
      categoryIds: (json['category_ids'] as List)
          .map((e) => CategoryId.fromJson(e))
          .toList(),
      variations: (json['variations'] as List)
          .map((e) => Variation.fromJson(e))
          .toList(),
      addOns: (json['add_ons'] as List)
          .map((e) => AddOn.fromJson(e))
          .toList(),
      price: (json['price'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      taxType: json['tax_type'] ?? '',
      discount: (json['discount'] as num).toDouble(),
      discountType: json['discount_type'] ?? '',
      availableTimeStarts: json['available_time_starts'] ?? '',
      availableTimeEnds: json['available_time_ends'] ?? '',
      veg: json['veg'] ?? 0,
      status: json['status'] ?? 0,
      restaurantId: json['restaurant_id'] ?? 0,
      imageFullUrl: json['image_full_url'],
      restaurantName: json['restaurant_name'] ?? '',
      cuisines: (json['cuisines'] as List)
          .map((e) => Cuisine.fromJson(e))
          .toList(),
    );
  }
}

class CategoryId {
  final String id;
  final int position;

  CategoryId({required this.id, required this.position});

  factory CategoryId.fromJson(Map<String, dynamic> json) {
    return CategoryId(
      id: json['id'],
      position: json['position'],
    );
  }
}

class Variation {
  final int variationId;
  final String name;
  final String type;
  final String min;
  final String max;
  final String requiredOption;
  final List<VariationValue> values;

  Variation({
    required this.variationId,
    required this.name,
    required this.type,
    required this.min,
    required this.max,
    required this.requiredOption,
    required this.values,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      variationId: json['variation_id'],
      name: json['name'],
      type: json['type'],
      min: json['min'],
      max: json['max'],
      requiredOption: json['required'],
      values: (json['values'] as List)
          .map((e) => VariationValue.fromJson(e))
          .toList(),
    );
  }
}

class VariationValue {
  final String label;
  final double optionPrice;
  final int optionId;

  VariationValue({
    required this.label,
    required this.optionPrice,
    required this.optionId,
  });

  factory VariationValue.fromJson(Map<String, dynamic> json) {
    return VariationValue(
      label: json['label'],
      optionPrice: (json['optionPrice'] as num).toDouble(),
      optionId: json['option_id'],
    );
  }
}

class AddOn {
  final int id;
  final String name;
  final double price;

  AddOn({required this.id, required this.name, required this.price});

  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

class Cuisine {
  final int id;
  final String name;
  final String? image;

  Cuisine({required this.id, required this.name, this.image});

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
