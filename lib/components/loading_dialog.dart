import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //circular progress bar
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 14),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
            ),
          ),

          const SizedBox(height: 16),

          Text('$message, Please wait...'),
        ],
      ),
    );
  }
}
