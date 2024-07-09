class UserLocation {
  String url;
  DateTime created;
  DateTime updated;
  String taker;
  String message;
  double latitude;
  double longitude;

  UserLocation({
    required this.url,
    required this.created,
    required this.updated,
    required this.taker,
    required this.message,
    required this.latitude,
    required this.longitude,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      url: json['securityCode'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      taker: json['taker'],
      message: json['message'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = url;
    data['taker'] = taker;
    data['message'] = message;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
