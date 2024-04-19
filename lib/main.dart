import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '.data/user_data_SharedPreferences/app_user_data.dart';
import 'components/Dragabble FAB.dart';
import 'view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserDataProvider()),
          ChangeNotifierProvider(create: (context) => FabPosition()),
        ],
        child: MaterialApp(
          title: 'Location Tracker',
          theme: ThemeData(
              primaryColor: Colors.black,
              fontFamily: 'Roboto',
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shadowColor: Colors.grey,
                      elevation: 20,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))))),
              inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  alignment: Alignment.centerLeft,
                ),
              )),
          // ThemeData(
          //   //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          //   fontFamily: GoogleFonts.outfit().fontFamily,
          //   textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.black)),
          //   useMaterial3: true,
          // ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ));
  }
}
