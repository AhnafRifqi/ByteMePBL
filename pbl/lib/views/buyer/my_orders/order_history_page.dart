import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/order_provider.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pesanan')),
      body: orders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (orderList) {
          if (orderList.isEmpty) {
            return const Center(child: Text('Tidak ada pesanan'));
          }

          return ListView.builder(
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              final order = orderList[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Pesanan ${order.id.substring(0, 8)}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status: ${_getStatusLabel(order.status)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Total: Rp ${order.totalHarga.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/order-detail',
                      arguments: order.id,
                    );
                  },
                  trailing: _getStatusIcon(order.status),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'menunggu':
        return '⏳ Menunggu Pembayaran';
      case 'diproses':
        return '📦 Sedang Diproses';
      case 'dikirim':
        return '🚚 Sedang Dikirim';
      case 'selesai':
        return '✅ Selesai';
      case 'dibatalkan':
        return '❌ Dibatalkan';
      default:
        return status;
    }
  }

  Icon _getStatusIcon(String status) {
    switch (status) {
      case 'selesai':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'dikirim':
        return const Icon(Icons.local_shipping, color: Colors.blue);
      case 'dibatalkan':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.schedule, color: Colors.orange);
    }
  }
}
