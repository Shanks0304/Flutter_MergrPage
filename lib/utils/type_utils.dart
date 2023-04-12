
import 'package:flutter/material.dart';

class TypeClass {
  static ButtonStyle srButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 15, 54, 87),
    shape: const StadiumBorder(),
  );
  static ButtonStyle mrButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 112, 15, 15),
    shape: const StadiumBorder(),
  );

  static ButtonStyle ulButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    padding: EdgeInsets.zero,
    shape: const CircleBorder(),
  );
  static TextStyle bodyTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 13,
  );
}
