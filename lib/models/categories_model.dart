class CategoryModel {
  final int id;
  final String name;
  final String? image;
  final int parentId;
  final int position;
  final int status;
  final String createdAt;
  final String updatedAt;
  final int priority;
  final String slug;
  final int productsCount;
  final int childesCount;
  final String? imageFullUrl;
  final List<TranslationModel> translations;
  final List<StorageModel> storage;
  final List<CategoryModel> childes;

  CategoryModel({
    required this.id,
    required this.name,
    this.image,
    required this.parentId,
    required this.position,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.priority,
    required this.slug,
    required this.productsCount,
    required this.childesCount,
    this.imageFullUrl,
    required this.translations,
    required this.storage,
    required this.childes,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'],
      parentId: json['parent_id'] ?? 0,
      position: json['position'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      priority: json['priority'] ?? 0,
      slug: json['slug'] ?? '',
      productsCount: json['products_count'] ?? 0,
      childesCount: json['childes_count'] ?? 0,
      imageFullUrl: json['image_full_url'],
      translations: (json['translations'] as List<dynamic>? ?? [])
          .map((e) => TranslationModel.fromJson(e))
          .toList(),
      storage: (json['storage'] as List<dynamic>? ?? [])
          .map((e) => StorageModel.fromJson(e))
          .toList(),
      childes: (json['childes'] as List<dynamic>? ?? [])
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
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
