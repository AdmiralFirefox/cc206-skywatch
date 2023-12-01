class SearchedPlace {
  final String id;
  final String placeName;
  final double placeTemp;

  SearchedPlace(
      {required this.id, required this.placeName, required this.placeTemp});

  factory SearchedPlace.fromJson(Map<String, dynamic> json) {
    return SearchedPlace(
      id: json['id'],
      placeName: json['placeName'],
      placeTemp: json['placeTemp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placeName': placeName,
      'placeTemp': placeTemp,
    };
  }
}
