import 'package:flutter/material.dart';
import 'package:myapp/utils/type_utils.dart';

class SavedPath extends StatelessWidget {
  const SavedPath({super.key, required this.path});

  final String? path;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (path != null) ? path!.split("/").last : "",
            style: TypeClass.bodyTextStyle,
          ),
        ],
      ),
    );
  }
}
