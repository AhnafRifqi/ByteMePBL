import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/order_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String pesananId;

  const OrderDetailScreen({Key? key, required this.pesananId})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdProvider(pesananId));
    final details = ref.watch(orderDetailsProvider(pesananId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            order.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
              data: (orderData) {
                if (orderData == null) {
                  return const Text('Pesanan tidak ditemukan');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID Pesanan: ${orderData.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Tanggal: ${orderData.tglPesanan}'),
                    Text('Status: ${orderData.status}'),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
            const Text(
              'Detail Produk',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            details.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
              data: (detailList) {
                return Column(
                  children: detailList
                      .map(
                        (detail) => ListTile(
                          title: Text('Produk: ${detail.produkId}'),
                          subtitle: Text('Jumlah: ${detail.jumlah}'),
                          trailing: Text(
                            'Rp ${detail.subtotal.toStringAsFixed(0)}',
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 32),
            order.when(
              loading: () => const SizedBox(),
              error: (err, stack) => const SizedBox(),
              data: (orderData) {
                if (orderData?.status != 'selesai') {
                  return const SizedBox();
                }

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/review');
                    },
                    child: const Text('Beri Review'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
