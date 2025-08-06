import 'package:flutter/material.dart';

class DialogService {
  final GlobalKey<NavigatorState> dialogNavigationKey = GlobalKey<NavigatorState>();

  Future<void> showErrorDialog(String title, String message) async {
    return showDialog(
      context: dialogNavigationKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showSnackBar(String message, {bool isError = false}) {
    final context = dialogNavigationKey.currentContext!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,

        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> showBottomSheet(Widget content) async {
    return showModalBottomSheet(
      context: dialogNavigationKey.currentContext!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => content,
    );
  }

  Future<bool?> showConfirmationDialog(String title, String message) async {
    return showDialog<bool>(
      context: dialogNavigationKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
