import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cart items ketika screen dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartController>().fetchCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: Consumer<CartController>(
        builder: (context, cartController, child) {
          if (cartController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartController.error != null) {
            return Center(child: Text('Error: ${cartController.error}'));
          }

          final items = cartController.cartItems;

          if (items.isEmpty) {
            return const Center(child: Text('Keranjang kosong'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text('Produk ${item.produkId}'),
                      subtitle: Text('Jumlah: ${item.jumlah}'),
                      trailing: Text('Rp ${item.subtotal.toStringAsFixed(0)}'),
                      onLongPress: () async {
                        await cartController.removeFromCart(item.id);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:'),
                        Text('Rp ${cartController.total.toStringAsFixed(0)}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout');
                        },
                        child: const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
