import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../services/pembayaran_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String? selectedMethod;
  final pembayaranService = PembayaranService();

  @override
  Widget build(BuildContext context) {
    final cartTotal = ref.watch(cartTotalProvider);
    final paymentMethods = pembayaranService.getPaymentMethods();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...paymentMethods.map((method) {
              return RadioListTile<String>(
                title: Text(_getMethodLabel(method)),
                value: method,
                groupValue: selectedMethod,
                onChanged: (value) {
                  setState(() => selectedMethod = value);
                },
              );
            }).toList(),
            const SizedBox(height: 32),
            const Text(
              'Total Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            cartTotal.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
              data: (total) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedMethod == null
                            ? null
                            : () {
                                _processCheckout(context, total);
                              },
                        child: const Text('Proses Pembayaran'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processCheckout(BuildContext context, double total) async {
    try {
      // Get cart items
      final cartItems = await ref.read(cartItemsProvider.future);

      // Prepare items for order
      final items = cartItems
          .map(
            (item) => {
              'produk_id': item.produkId,
              'jumlah': item.jumlah,
              'harga_satuan': item.hargaSatuan,
            },
          )
          .toList();

      // Create order
      final pesananId = await ref
          .read(orderNotifierProvider.notifier)
          .createOrder(items, total);

      if (pesananId != null) {
        // Create payment
        await pembayaranService.createPayment(pesananId, selectedMethod!);

        // Clear cart
        await ref.read(cartNotifierProvider.notifier).clearCart();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesanan berhasil dibuat')),
          );
          Navigator.pushReplacementNamed(context, '/order-history');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  String _getMethodLabel(String method) {
    switch (method) {
      case 'transfer':
        return '💳 Transfer Bank';
      case 'cod':
        return '💰 Bayar di Tempat (COD)';
      case 'ewallet':
        return '📱 E-Wallet';
      case 'kartu_kredit':
        return '🏦 Kartu Kredit';
      default:
        return method;
    }
  }
}
