class BookmarkedPlace {
  final String id;
  final String placeName;

  BookmarkedPlace({required this.id, required this.placeName});

  factory BookmarkedPlace.fromJson(Map<String, dynamic> json) {
    return BookmarkedPlace(
      id: json['id'],
      placeName: json['placeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placeName': placeName,
    };
  }
}
