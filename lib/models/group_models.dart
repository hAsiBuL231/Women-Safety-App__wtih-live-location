class Group {
  String groupId;
  String name;
  String imageUrl;
  List<String> users;

  Group({
    required this.groupId,
    required this.name,
    required this.imageUrl,
    required this.users,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      users: List<String>.from(json['users']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'name': name,
      'imageUrl': imageUrl,
      'users': users,
    };
  }
}
