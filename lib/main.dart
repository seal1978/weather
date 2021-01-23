import 'package:flutter/material.dart';

 

import 'ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Weather(Rakuten)',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: HomePage(),
    );
  }
}
