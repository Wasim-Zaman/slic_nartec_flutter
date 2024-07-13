class ApiResponse<T> {
  final String message;
  final int status;
  final bool success;
  final T data;

  ApiResponse({
    required this.message,
    required this.status,
    required this.data,
    required this.success,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      message: json['message'] as String,
      status: json['status'] as int,
      success: json['success'] as bool,
      data: fromJsonT(json['data']),
    );
  }
}
