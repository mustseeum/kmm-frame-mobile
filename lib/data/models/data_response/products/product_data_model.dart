import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/data_response/products/product_color_model.dart';
import 'package:kacamatamoo/data/models/data_response/products/product_images.dart';
import 'package:kacamatamoo/data/models/data_response/products/product_tags_model.dart';
part 'product_data_model.g.dart';

@JsonSerializable()
class ProductDataModel {
  final String id;
  final String brand;
  final String model;
  final int
  price; // in smallest currency unit (e.g. cents) or whole integer for Rp
  final String color;
  final String size; // human readable size (e.g. "x mm - x mm - x mm")
  final String material;
  final List<ProductImages> imageUrls;
  final List<ProductColorModel> colorOptions; // hex or color name
  final List<ProductTagsModel> tags;
  final String description;
  final bool isBestOffer;

  ProductDataModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.price,
    required this.color,
    required this.size,
    required this.material,
    required this.imageUrls,
    required this.colorOptions,
    required this.tags,
    required this.description,
    this.isBestOffer = false,
  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDataModelToJson(this);
}
