class BaseResponse<T> {
  final int statusCode;
  final String message;
  final bool status;
  final T? data;

  BaseResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return BaseResponse(
      statusCode: json['status_code'] as int? ?? 0,
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
