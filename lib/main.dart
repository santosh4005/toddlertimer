import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toddlertimer/provider/times.dart';
import './screens/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderToddlerTimes(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Toddler Timer'),
      ),
    );
  }
}
