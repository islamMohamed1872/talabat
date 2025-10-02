class PopularProducts {
  final int totalSize;
  final int limit;
  final int offset;
  final List<Product> products;

  PopularProducts({
    required this.totalSize,
    required this.limit,
    required this.offset,
    required this.products,
  });

  factory PopularProducts.fromJson(Map<String, dynamic> json) {
    return PopularProducts(
      totalSize: json['total_size'],
      limit: int.parse(json['limit'].toString()),
      offset: int.parse(json['offset'].toString()),
      products: (json['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String image;
  final String imageFullUrl;
  final int categoryId;
  final List<CategoryId> categoryIds;
  final List<Variation> variations;
  final List<AddOn> addOns;
  final double price;
  final double tax;
  final String taxType;
  final double discount;
  final String discountType;
  final List<Cuisine> cuisines;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.categoryId,
    required this.categoryIds,
    required this.variations,
    required this.addOns,
    required this.price,
    required this.tax,
    required this.taxType,
    required this.discount,
    required this.discountType,
    required this.cuisines,
    required this.imageFullUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      imageFullUrl: json['image_full_url'] ?? '',
      categoryId: json['category_id'],
      categoryIds: (json['category_ids'] as List)
          .map((e) => CategoryId.fromJson(e))
          .toList(),
      variations: (json['variations'] as List)
          .map((e) => Variation.fromJson(e))
          .toList(),
      addOns: (json['add_ons'] as List).map((e) => AddOn.fromJson(e)).toList(),
      price: (json['price'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      taxType: json['tax_type'] ?? '',
      discount: (json['discount'] as num).toDouble(),
      discountType: json['discount_type'] ?? '',
      cuisines: (json['cuisines'] as List)
          .map((e) => Cuisine.fromJson(e))
          .toList(),
    );
  }
}

class CategoryId {
  final int id;
  final int position;

  CategoryId({
    required this.id,
    required this.position,
  });

  factory CategoryId.fromJson(Map<String, dynamic> json) {
    return CategoryId(
      id: int.parse(json['id'].toString()),
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
  final String requiredField;
  final List<VariationValue> values;

  Variation({
    required this.variationId,
    required this.name,
    required this.type,
    required this.min,
    required this.max,
    required this.requiredField,
    required this.values,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      variationId: json['variation_id'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      min: json['min'] ?? '',
      max: json['max'] ?? '',
      requiredField: json['required'] ?? '',
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
      label: json['label'] ?? '',
      optionPrice: (json['optionPrice'] as num).toDouble(),
      optionId: json['option_id'],
    );
  }
}

class AddOn {
  final int id;
  final String name;
  final double price;

  AddOn({
    required this.id,
    required this.name,
    required this.price,
  });

  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
      id: json['id'],
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
    );
  }
}

class Cuisine {
  final int id;
  final String name;
  final String image;

  Cuisine({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
