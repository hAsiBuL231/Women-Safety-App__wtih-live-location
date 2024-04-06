class Users {
  String securityCode;
  String email;
  String name;
  int phone;
  String imageUrl;
  double latitude;
  double longitude;

  Users({
    required this.securityCode,
    required this.email,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      securityCode: json['securityCode'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      imageUrl: json['imageUrl'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'securityCode': securityCode,
      'email': email,
      'name': name,
      'phone': phone,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
