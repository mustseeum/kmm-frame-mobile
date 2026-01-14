import 'package:json_annotation/json_annotation.dart';
part 'product_color_model.g.dart';

@JsonSerializable()
class ProductColorModel {
  String id;
  String name;
  String hexCode;
  ProductColorModel({
    required this.id,
    required this.name,
    required this.hexCode,
  });
  factory ProductColorModel.fromJson(Map<String, dynamic> json) =>
      _$ProductColorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductColorModelToJson(this);
}
