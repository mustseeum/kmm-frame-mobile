import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/data_response/session/result_data.dart';
part 'session_dm.g.dart';

@JsonSerializable()
class SessionDm {
  String? activity_type;
  String? created_at;
  int? duration_minutes;
  String? ended_at;
  String? last_activity_at;
  ResultData? result_data;
  String? session_id;
  String? started_at;
  String? status;
  String? store_code;
  int? store_id;
  String? store_name;
  int? timeout_duration_minutes;
  String? updated_at;
  String? user_email;
  String? user_id;
  String? user_name;

  SessionDm({
    this.user_name,
    this.activity_type,
    this.created_at,
    this.duration_minutes,
    this.ended_at,
    this.last_activity_at,
    this.result_data,
    this.session_id,
    this.started_at,
    this.status,
    this.store_code,
    this.store_id,
    this.store_name,
    this.timeout_duration_minutes,
    this.updated_at,
    this.user_email,
    this.user_id,
  });

  factory SessionDm.fromJson(Map<String, dynamic> json) =>
      _$SessionDmFromJson(json);

  Map<String, dynamic> toJson() => _$SessionDmToJson(this);
}
