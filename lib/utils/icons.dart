import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointIcons {
  static IconData getIconByCodePoint(int codePoint) {
    return IconData(codePoint,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage,
        matchTextDirection: true);
  }
}
