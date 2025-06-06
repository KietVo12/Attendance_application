import 'package:flutter/material.dart';

Future<void> showAnimatedSuccessDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: true, // Allows dismissing by tapping outside
    builder: (context) => _AnimatedSuccessDialog(),
  );
}

class _AnimatedSuccessDialog extends StatefulWidget {
  @override
  __AnimatedSuccessDialogState createState() => __AnimatedSuccessDialogState();
}

class __AnimatedSuccessDialogState extends State<_AnimatedSuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 40,
            ),
          ),
          SizedBox(width: 8),
          Text('Success'),
        ],
      ),
      //content: Text('Created successfully.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

Future<void> showAnimatedFailureDialog(BuildContext context, String content) async {
  await showDialog(
    context: context,
    barrierDismissible: true, // Allows dismissing by tapping outside
    builder: (context) => _AnimatedFailureDialog(content: content),
  );
}

class _AnimatedFailureDialog extends StatefulWidget {
  const _AnimatedFailureDialog({required this.content});
  final String content;
  @override
  __AnimatedFailureDialogState createState() => __AnimatedFailureDialogState();
}

class __AnimatedFailureDialogState extends State<_AnimatedFailureDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              Icons.error,
              color: Colors.red,
              size: 40,
            ),
          ),
          SizedBox(width: 8),
          Text('Error'),
        ],
      ),
      // Optionally include content message if needed:
      // content: Text('Operation failed.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          child: Text('OK'),
        ),
      ],
      content: Text(widget.content, style: TextStyle(color: Colors.red)),
    );
  }
}