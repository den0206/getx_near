import 'dart:convert';

class Pages<T> {
  final List<T> pageFeeds;
  final PageInfo pageInfo;

  Pages(this.pageFeeds, this.pageInfo);

  factory Pages.fromMap(Map<String, dynamic> map, Function fromJsonModel) {
    final items = map["pageFeeds"].cast<Map<String, dynamic>>();
    return Pages(List<T>.from(items.map((itemJson) => fromJsonModel(itemJson))),
        PageInfo.fromMap(map["pageInfo"]));
  }
}

class PageInfo {
  final String? nextPageCursor;
  final bool hasNextpage;
  PageInfo({
    required this.nextPageCursor,
    required this.hasNextpage,
  });

  Map<String, dynamic> toMap() {
    return {
      'nextPageCursor': nextPageCursor,
      'hasNextpage': hasNextpage,
    };
  }

  factory PageInfo.fromMap(Map<String, dynamic> map) {
    return PageInfo(
      nextPageCursor: map['nextPageCursor'],
      hasNextpage: map['hasNextpage'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PageInfo.fromJson(String source) =>
      PageInfo.fromMap(json.decode(source));
}
