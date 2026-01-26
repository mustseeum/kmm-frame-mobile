import 'package:json_annotation/json_annotation.dart';
part 'options.g.dart';

@JsonSerializable()
class Options {
  final String label;
  final String value;

  Options({
    required this.label,
    required this.value,
  });

  factory Options.fromJson(Map<String, dynamic> json) =>
      _$OptionsFromJson(json);

  Map<String, dynamic> toJson() => _$OptionsToJson(this);
}