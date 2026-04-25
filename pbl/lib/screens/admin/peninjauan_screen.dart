import 'package:flutter/material.dart';

class PeninjaauanScreen extends StatefulWidget {
  const PeninjaauanScreen({Key? key}) : super(key: key);

  @override
  State<PeninjaauanScreen> createState() => _PeninjaauanScreenState();
}

class _PeninjaauanScreenState extends State<PeninjaauanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peninjauan Admin')),
      body: const Center(child: Text('Peninjauan Screen')),
    );
  }
}
