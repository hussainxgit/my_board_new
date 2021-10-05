import 'package:flutter/material.dart';

showCustomSnackBar(BuildContext context, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
