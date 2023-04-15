// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:myapp/utils/type_utils.dart';

class BottomView extends StatelessWidget {
  const BottomView({super.key});
  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: sHeight * 0.19 - 6,
      child: Row(
        children: [
          Container(
            width: sWidth - 60 - sHeight * 0.05,
            height: sHeight * 0.05,
            padding: const EdgeInsets.only(right: 30),
            child: OutlinedButton(
              onPressed: () {},
              style: TypeClass.srButtonStyle,
              child: const Text("Save Recording",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  )),
            ),
          ),
          SizedBox(
            width: sHeight * 0.05,
            height: sHeight * 0.05,
            child: OutlinedButton(
              onPressed: () {},
              style: TypeClass.ulButtonStyle,
              child: Icon(
                Icons.file_upload_outlined,
                color: Colors.black,
                size: sHeight * 0.06 * 0.8,
              ),
              // color: Colors.white,
              // icon: Icon(
              //   Icons.file_upload_outlined,
              //   color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
