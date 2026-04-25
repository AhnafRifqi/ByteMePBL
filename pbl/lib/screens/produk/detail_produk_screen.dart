import 'package:flutter/material.dart';

class DetailProdukScreen extends StatefulWidget {
  final String produkId;

  const DetailProdukScreen({Key? key, required this.produkId})
    : super(key: key);

  @override
  State<DetailProdukScreen> createState() => _DetailProdukScreenState();
}

class _DetailProdukScreenState extends State<DetailProdukScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: const Center(child: Text('Detail Produk Screen')),
    );
  }
}
