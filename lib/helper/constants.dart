import 'package:flutter/material.dart';

//Constants that can be used by any widget through out the applicaiton
const gradientBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
  colors: [
    Colors.green,
    Colors.amber,
    Colors.orange,
    Colors.pink,
  ],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
));

const gradientBoxDecoration1 = BoxDecoration(
    gradient: LinearGradient(
  colors: [
    Colors.pink, 
    Colors.purple,
    Colors.blue,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
));
