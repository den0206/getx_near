import 'dart:convert';

class Pages<T> {
  final List<T> pageFeeds;
  final PageInfo pageInfo;

  Pages(this.pageFeeds, this.pageInfo);

  factory Pages.fromMap(
    Map<String, dynamic> map,
    Function fromJsonModel, [
    dynamic relationData,
  ]) {
    final items = map["pageFeeds"].cast<Map<String, dynamic>>();

    if (relationData != null) {
      return Pages(
        List<T>.from(
          items.map((itemJson) => fromJsonModel(itemJson, relationData)),
        ),
        PageInfo.fromMap(map["pageInfo"]),
      );
    } else {
      return Pages(
        List<T>.from(items.map((itemJson) => fromJsonModel(itemJson))),
        PageInfo.fromMap(map["pageInfo"]),
      );
    }
  }
}

class PageInfo {
  final String? nextPageCursor;
  final bool hasNextPage;
  PageInfo({required this.nextPageCursor, required this.hasNextPage});

  Map<String, dynamic> toMap() {
    return {'nextPageCursor': nextPageCursor, 'hasNextPage': hasNextPage};
  }

  factory PageInfo.fromMap(Map<String, dynamic> map) {
    return PageInfo(
      nextPageCursor: map['nextPageCursor'],
      hasNextPage: map['hasNextPage'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PageInfo.fromJson(String source) =>
      PageInfo.fromMap(json.decode(source));
}
