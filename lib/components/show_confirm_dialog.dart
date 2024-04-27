import 'package:flutter/material.dart';

void showConfirmDialog(BuildContext context, String title, String alertMessage,
    Function()? onConfirm) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(alertMessage),
            actions: [
              TextButton(
                onPressed: () {
                  onConfirm?.call();
                  Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ));
}
