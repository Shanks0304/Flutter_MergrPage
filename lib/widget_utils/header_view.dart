import 'package:flutter/material.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "APPNAME",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            child: CircleAvatar(
              radius: 26.5,
              backgroundColor: Color.fromARGB(255, 42, 102, 45),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/uchiha.jpg",
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
