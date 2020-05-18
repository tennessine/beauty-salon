import 'package:flutter/material.dart';
import 'package:flutterapp/ui/customers.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    routes: <String, WidgetBuilder>{
      '/home': (BuildContext context) => HomePage()
    },
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Customers();
  }
}
