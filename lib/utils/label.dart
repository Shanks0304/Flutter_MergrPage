import 'package:flutter/material.dart';
import 'package:myapp/utils/type_utils.dart';

class PathLabel extends StatelessWidget {
  const PathLabel({super.key, required this.fileName, required this.duration});

  final String fileName;
  final Duration duration;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filename: ${(fileName != "") ? fileName.split("/").last : ""}",
            style: TypeClass.bodyTextStyle,
          ),
          Text(
            "Time: ${(fileName != "") ? _printDuration(duration) : ""}",
            style: TypeClass.bodyTextStyle,
          ),
        ],
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
