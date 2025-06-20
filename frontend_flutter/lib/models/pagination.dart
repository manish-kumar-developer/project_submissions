class Pagination<T> {
  final List<T> data;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  Pagination({
    required this.data,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory Pagination.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJson,
      ) =>
      Pagination(
        data: (json['data'] as List).map((e) => fromJson(e)).toList(),
        currentPage: json['meta']['current_page'],
        perPage: json['meta']['per_page'],
        total: json['meta']['total'],
        lastPage: json['meta']['last_page'],
      );
}