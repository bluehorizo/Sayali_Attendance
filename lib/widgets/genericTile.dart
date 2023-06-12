import 'package:flutter/material.dart';

import '../themes/color.dart';

class GenericTile extends StatelessWidget {
  String title, mainText;
  GenericTile(this.title, this.mainText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 16),
          ),
        ),
        Text(
          mainText,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 16),
        )
      ],
    ));
  }
}
