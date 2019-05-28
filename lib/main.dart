import 'package:flutter/material.dart';
import 'package:mobile_app/Bloc/Themes.dart';
import 'package:mobile_app/Functions/GetTheme.dart';
import 'package:mobile_app/Views/UserCreation.dart';

main() {
  runApp(MainScreen());
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ThemeData appTheme;
  var dynamicTheme = ThemesChanger.instance();

  @override
  Widget build(BuildContext context) {
    // Entry Point
    return FutureBuilder(
        future: GetTheme().initialTheme(),
        builder: (context, themeSnapshot) {
          if (themeSnapshot.hasData) {
            return StreamBuilder(
              stream: dynamicTheme.themeStream,
              initialData: themeSnapshot.data,
              builder: (context, snapshot) {
                // print(snapshot.data);
                if (snapshot.hasData) {
                  return MaterialApp(
                    theme: snapshot.data,
                    home: LoginScreen(),
                  );
                } else {
                  return Container(color: Colors.blue);
                }
              },
            );
          } else {
            return MaterialApp(
              theme: ThemeData.dark(),
              home: Center(
                child: Text('Error Detected Please Contact The Developer'),
              ),
            );
          }
        });
  }
}
