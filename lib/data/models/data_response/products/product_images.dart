import 'package:json_annotation/json_annotation.dart';
part 'product_images.g.dart';

@JsonSerializable()
class ProductImages {
  final String url;
  final String altText;

  ProductImages({required this.url, required this.altText});

  factory ProductImages.fromJson(Map<String, dynamic> json) =>
      _$ProductImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImagesToJson(this);
}
