import 'package:json_annotation/json_annotation.dart';
part 'product_tags_model.g.dart';

@JsonSerializable()
class ProductTagsModel {
  final String name;
  final String category;

  ProductTagsModel({
    required this.name,
    required this.category,
  });

  factory ProductTagsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductTagsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductTagsModelToJson(this);
}