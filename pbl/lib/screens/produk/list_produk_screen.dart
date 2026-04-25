import 'package:flutter/material.dart';

class ListProdukScreen extends StatefulWidget {
  const ListProdukScreen({Key? key}) : super(key: key);

  @override
  State<ListProdukScreen> createState() => _ListProdukScreenState();
}

class _ListProdukScreenState extends State<ListProdukScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Produk')),
      body: const Center(child: Text('List Produk Screen')),
    );
  }
}
