import 'package:flutter/material.dart';
showLaoding(context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 40,
          width: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CircularProgressIndicator(),
              Text("Loading...")
            ],
          ),
        ),
      ));
}
