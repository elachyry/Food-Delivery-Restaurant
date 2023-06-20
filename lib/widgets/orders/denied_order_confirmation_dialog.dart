import 'package:flutter/material.dart';

class DeniedOrderConfirmationDialog {
  static Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Denied Confirmation',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                ),
          ),
          content: Text(
            'Do you want to Denied this order?',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false when cancel is pressed
              },
            ),
            ElevatedButton(
              child: Text(
                'Yes',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true when delete is pressed
              },
            ),
          ],
        );
      },
    );
  }
}
