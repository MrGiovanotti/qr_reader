import 'package:flutter/material.dart';
import 'package:qr_reader/src/screens/home_screen.dart';
import 'package:qr_reader/src/utils/routes_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.deepOrangeAccent),
      title: 'QR Reader',
      initialRoute: RoutesUtils.HOME_ROUTE,
      routes: {
        RoutesUtils.HOME_ROUTE: (context) => HomeScreen(),
      },
    );
  }
}
