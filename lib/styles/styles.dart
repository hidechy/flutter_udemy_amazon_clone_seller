import 'package:flutter/material.dart';

const pinkBackGround = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Colors.pinkAccent,
      Colors.purpleAccent,
    ],
    // ignore: use_named_constants
    begin: FractionalOffset(0, 0),
    // ignore: use_named_constants
    end: FractionalOffset(1, 0),
    stops: [0, 1],
  ),
);
