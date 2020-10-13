import 'package:boong_task/src/presentation/screens/add_kids.dart';
import 'package:flutter/material.dart';

import 'presentation/screens/add_data.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/view_data.dart';

class Boong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boong Task',
      theme: ThemeData(
        buttonColor: Colors.blue,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      home: HomeScreen(),
      routes: {
        AddDataScreen.routename: (context) => AddDataScreen(),
        ViewDataScreen.routename: (context) => ViewDataScreen(),
      },
    );
  }
}
