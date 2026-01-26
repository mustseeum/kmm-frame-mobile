// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDataModel _$ProductDataModelFromJson(Map<String, dynamic> json) =>
    ProductDataModel(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      price: (json['price'] as num).toInt(),
      color: json['color'] as String,
      size: json['size'] as String,
      material: json['material'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>)
          .map((e) => ProductImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      colorOptions: (json['colorOptions'] as List<dynamic>)
          .map((e) => ProductColorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => ProductTagsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String,
      isBestOffer: json['isBestOffer'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductDataModelToJson(ProductDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brand': instance.brand,
      'model': instance.model,
      'price': instance.price,
      'color': instance.color,
      'size': instance.size,
      'material': instance.material,
      'imageUrls': instance.imageUrls,
      'colorOptions': instance.colorOptions,
      'tags': instance.tags,
      'description': instance.description,
      'isBestOffer': instance.isBestOffer,
    };
