import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../services/services.dart';
import 'widgets.dart';

class ShamelessSelfPlug extends StatelessWidget {
  const ShamelessSelfPlug({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: RowSelector(
              selected: false,
              onTap: () {
                StorageServices().launchTheThing(
                  dorxWebsite,
                );
              },
              image: foodPic,
              text:
                  "Do you know any restaurants that may need this system?\n\nTap here to contact the $capitalizedAppName team and tell us all about it.",
            ),
          ),
        ],
      ),
    );
  }
}
