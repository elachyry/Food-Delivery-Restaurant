import 'package:flutter/material.dart';

class MarkOrderAsDeliveredConfirmationDialog {
  static Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Mark as delivered Confirmation',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                ),
          ),
          content: Text(
            'Do you want to mark this order as delivered?',
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade400),
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
