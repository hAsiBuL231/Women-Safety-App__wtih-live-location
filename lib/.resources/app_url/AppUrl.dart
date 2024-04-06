class AppUrl {

  // static const String baseUrl = "http://127.0.0.1:8000";
  // static const String baseUrl = "http://10.0.2.2:8000";


  //static const String baseUrl = "http://192.168.0.111:8000"; /// Mess Wifi
  static const String baseUrl = "http://192.168.0.103:8000"; /// basha

  //  --web-browser-flag "--disable-web-security"
  // python manage.py runserver 0.0.0.0:8000



  static const String registerUrl = '$baseUrl/auth/register';
  static const String loginUrl = '$baseUrl/auth/login';


  // static const String database = '$baseUrl/api';

  static const String groupsUrl = '$baseUrl/groups/';
  static const String usersUrl = '$baseUrl/users/';

}
