
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
    // List<Users> userList = [];
    // for (var user in json['users']) {
    //   user['securityCode'] = user['url'];
    //   user.remove('url');
    //   print(user);
    //   Users u = Users.fromJson(user);
    //   userList.add(u);
    // }

    return Group(
      groupId: json['url'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      users: List<String>.from(json['users']),
      // users: userList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': groupId,
      'name': name,
      'imageUrl': imageUrl,
      'users': users,
    };
  }
}
