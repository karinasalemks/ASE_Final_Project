import 'package:flutter/material.dart';

import 'bike_swap_suggestions.dart';
import 'dataTable.dart';
class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Test"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BikeSwapSuggestions(),
            BikeSwapSuggestions(),
          ],
        ),
      ),
    );
  }
}

