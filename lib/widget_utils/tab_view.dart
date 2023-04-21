import 'package:flutter/material.dart';
import 'package:mergr/utils/type_utils.dart';

class TabViewCustom extends StatelessWidget {
  const TabViewCustom({super.key, required this.tabController});

  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.04,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(255, 224, 224, 224)),
        ),
      ),
      child: TabBar(
        controller: tabController,
        indicatorColor: Colors.grey,
        labelColor: Colors.white,
        tabs: [
          // first tab [you can add an icon using the icon property]
          Tab(
            child: Container(
              child: Text(
                "MAIN",
                style: TypeClass.bodyTextStyle,
              ),
            ),
          ),

          // second tab [you can add an icon using the icon property]
          Tab(
            child: Text(
              "LEADERBOARD",
              style: TypeClass.bodyTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
