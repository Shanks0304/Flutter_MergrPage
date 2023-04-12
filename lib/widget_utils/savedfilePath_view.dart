import 'package:flutter/material.dart';
import 'package:myapp/utils/type_utils.dart';

class savedfilePath_view extends StatelessWidget {
  const savedfilePath_view({super.key, required this.path});

  final String? path;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${(path != null) ? path!.split("/").last : ""}",
            style: TypeClass.bodyTextStyle,
          ),
        ],
      ),
    );
  }
}
