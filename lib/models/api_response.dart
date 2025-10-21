/// Generic API Response Model for handling API responses
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String error, {int? statusCode, String? message}) {
    return ApiResponse<T>(
      success: false,
      error: error,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic>)? dataParser,
  }) {
    final success = json['success'] == true;
    final message = json['message']?.toString() ?? json['msg']?.toString();

    T? parsedData;
    if (success && dataParser != null) {
      try {
        parsedData = dataParser(json);
      } catch (e) {
        return ApiResponse.error('Failed to parse response data: $e');
      }
    }

    return ApiResponse<T>(
      success: success,
      message: message,
      data: parsedData,
      error: success ? null : message,
    );
  }

  /// Check if response has data
  bool get hasData => data != null;

  /// Check if response has error
  bool get hasError => error != null && error!.isNotEmpty;

  /// Get display message (success message or error)
  String get displayMessage => message ?? error ?? '';

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, hasData: $hasData, error: $error)';
  }
}

/// Pagination Model for paginated responses
class PaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;
  final String? prevPageUrl;

  PaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      nextPageUrl: json['next_page_url']?.toString(),
      prevPageUrl: json['prev_page_url']?.toString(),
    );
  }

  /// Check if there are more pages
  bool get hasNextPage => currentPage < lastPage;

  /// Check if there are previous pages
  bool get hasPrevPage => currentPage > 1;

  /// Get total pages
  int get totalPages => lastPage;

  @override
  String toString() {
    return 'PaginationModel(page: $currentPage/$lastPage, total: $total)';
  }
}

/// Paginated API Response Model
class PaginatedResponse<T> extends ApiResponse<List<T>> {
  final PaginationModel? pagination;

  PaginatedResponse({
    required super.success,
    super.message,
    super.data,
    super.error,
    super.statusCode,
    this.pagination,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json, {
    required List<T> Function(Map<String, dynamic>) dataParser,
  }) {
    final success = json['success'] == true;
    final message = json['message']?.toString() ?? json['msg']?.toString();

    List<T>? parsedData;
    PaginationModel? pagination;

    if (success) {
      try {
        parsedData = dataParser(json);
        if (json['pagination'] != null) {
          pagination = PaginationModel.fromJson(json['pagination']);
        }
      } catch (e) {
        return PaginatedResponse(
          success: false,
          error: 'Failed to parse response data: $e',
        );
      }
    }

    return PaginatedResponse(
      success: success,
      message: message,
      data: parsedData,
      error: success ? null : message,
      pagination: pagination,
    );
  }

  /// Check if there are more pages to load
  bool get hasNextPage => pagination?.hasNextPage ?? false;

  /// Get current page
  int get currentPage => pagination?.currentPage ?? 1;

  /// Get total pages
  int get totalPages => pagination?.totalPages ?? 1;
}
