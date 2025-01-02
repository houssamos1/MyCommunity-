import 'package:flutter/material.dart';

//displayerror to user

void displayMessageToUser( String message,BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title:  Text('Error'),

    ),
  );
}