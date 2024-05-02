class AppUrl {

  // static const String baseUrl = "http://127.0.0.1:8000";
  // static const String baseUrl = "http://10.0.2.2:8000";


   static const String baseUrl = "http://192.168.0.110:8000"; /// Mess Wifi
  // static const String baseUrl = "http://192.168.0.108:8000"; /// basha
  ///  192.168.42.172
  // static const String baseUrl = "http://192.168.42.172:8000"; /// mobile

  // Dep wifi CoU - 10.18.172.135
  // static const String baseUrl = "http://10.18.172.135:8000"; /// Dep wifi CoU

  //  --web-browser-flag "--disable-web-security"
  // python manage.py runserver 0.0.0.0:8000



  static const String registerUrl = '$baseUrl/auth/register';
  static const String loginUrl = '$baseUrl/auth/login';


  // static const String database = '$baseUrl/api';

  static const String usersUrl = '$baseUrl/users/';
  static const String groupsUrl = '$baseUrl/groups/';

  static const String locationUrl = '$baseUrl/locations/';


}
