import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.label,
      required this.color,
      required this.buttonStyle,
      required this.onPressFunc});

  final String label;
  final Color? color;
  final ButtonStyle buttonStyle;
  final void Function()? onPressFunc;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        height: MediaQuery.of(context).size.height * 0.05,
        child: OutlinedButton(
          onPressed: onPressFunc,
          style: buttonStyle,
          child: Text(label,
              style: TextStyle(
                color: color,
                fontSize: 15,
              )),
        ),
      ),
    );
  }
}
