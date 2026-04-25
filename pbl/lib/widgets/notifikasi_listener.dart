import 'package:flutter/material.dart';

class NotifikasiListener extends StatefulWidget {
  final Widget child;

  const NotifikasiListener({Key? key, required this.child}) : super(key: key);

  @override
  State<NotifikasiListener> createState() => _NotifikasiListenerState();
}

class _NotifikasiListenerState extends State<NotifikasiListener> {
  @override
  void initState() {
    super.initState();
    // TODO: Initialize notification listeners
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
