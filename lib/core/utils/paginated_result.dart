class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasMore;

  PaginatedResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  }) : hasMore = (page * pageSize) < totalCount;
}