import 'package:flutter/material.dart';

class PlayBtn extends StatelessWidget {
  const PlayBtn(
      {super.key, required this.playState, required this.onPressFunc});

  final bool playState;
  final void Function()? onPressFunc;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressFunc,
      child: playState
          ? const Icon(
              Icons.pause_circle_outline_outlined,
              size: 40,
              color: Color(0xFFFFFFFF),
            )
          : const Icon(
              Icons.play_circle_outline_outlined,
              size: 40,
              color: Color(0xFFFFFFFF),
            ),
    );
  }
}
