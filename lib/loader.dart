import 'package:flutter/material.dart';

import 'center_loader.dart';

class Loader {
  static showUnDismissibleLoader(BuildContext context) => showDialog(
        context: context,
        builder: (context) => CenterCircularLoader(),
        barrierDismissible: false,
      );

  static showDismissibleLoader(BuildContext context) => showDialog(
        context: context,
        builder: (context) => CenterCircularLoader(),
        barrierDismissible: false,
      );

  static hideDialog(BuildContext context) => Navigator.pop(context);
}
