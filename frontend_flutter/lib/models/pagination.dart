class PaginationResponse<T> {
  final String status;
  final List<T> data;
  final PaginationMeta pagination;

  PaginationResponse({
    required this.status,
    required this.data,
    required this.pagination,
  });

  factory PaginationResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return PaginationResponse<T>(
      status: json['status'],
      data: (json['data'] as List).map<T>((item) => fromJson(item)).toList(),
      pagination: PaginationMeta.fromJson(json['pagination']),
    );
  }
}

class PaginationMeta {
  final int? nextCursor;
  final bool hasMore;
  final int limit;

  PaginationMeta({
    this.nextCursor,
    required this.hasMore,
    required this.limit,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      nextCursor: json['next_cursor'],
      hasMore: json['has_more'],
      limit: json['limit'],
    );
  }
}