import 'package:flutter/material.dart';

import 'add_data.dart';
import 'view_data.dart';

class HomeScreen extends StatelessWidget {
  static const routename = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boong Task'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              textColor: Colors.white,
              child: Text('ADD DATA'),
              onPressed: () => Navigator.of(context).pushNamed(AddDataScreen.routename),
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton(
              textColor: Colors.white,
              child: Text('VIEW DATA'),
              onPressed: () => Navigator.of(context).pushNamed(ViewDataScreen.routename),
            ),
          ],
        ),
      ),
    );
  }
}
