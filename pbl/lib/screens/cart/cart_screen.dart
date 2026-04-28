import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/cart_provider.dart';
import '../checkout/checkout_screen.dart';

// ============================================================
// CART SCREEN - Polished UI dengan Supabase backend
// Menggantikan: pbl/lib/screens/cart/cart_screen.dart
// ============================================================

class CartScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;
  const CartScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final Set<String> _selectedIds = {};
  bool _isSelectAll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartNotifierProvider.notifier);
    });
  }

  String _formatRupiah(double number) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(number);
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final cartTotal = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: widget.isEmbedded
            ? null
            : Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFFE8E8F0),
                    borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF2A2A2A), size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
        title: cartItems.when(
          loading: () => const Text('Keranjang',
              style: TextStyle(
                  color: Color(0xFF2A2A2A),
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          error: (_, __) => const Text('Keranjang',
              style: TextStyle(
                  color: Color(0xFF2A2A2A),
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          data: (items) => Row(
            children: [
              const Text('Keranjang',
                  style: TextStyle(
                      color: Color(0xFF2A2A2A),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(width: 8),
              if (items.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xFF5A72C6),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('${items.length}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
            ],
          ),
        ),
      ),
      body: cartItems.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Color(0xFF5A72C6))),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text('Gagal memuat keranjang',
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 15)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.refresh(cartItemsProvider),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A72C6),
                    foregroundColor: Colors.white),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) return _buildEmptyCart();
          // Sync selected IDs
          final validIds = items.map((e) => e.id).toSet();
          _selectedIds.removeWhere((id) => !validIds.contains(id));

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, thickness: 0.2),
                        itemBuilder: (ctx, i) {
                          final item = items[i];
                          return _buildCartItem(
                            id: item.id,
                            produkId: item.produkId,
                            jumlah: item.jumlah,
                            harga: item.hargaSatuan,
                            subtotal: item.subtotal,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              cartTotal.when(
                loading: () => const SizedBox(height: 80),
                error: (_, __) => const SizedBox(height: 80),
                data: (total) => _buildBottomBar(total, items.length),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem({
    required String id,
    required String produkId,
    required int jumlah,
    required double harga,
    required double subtotal,
  }) {
    final isSelected = _selectedIds.contains(id);
    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade400,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 24),
            Text('Hapus',
                style: TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.delete_outline_rounded,
                        color: Colors.red.shade400, size: 22),
                    const SizedBox(width: 8),
                    const Text('Hapus Item',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 12),
                  Text(
                      'Hapus produk ini dari keranjang?',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.4)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text('Batal',
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8))),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Hapus',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onDismissed: (_) {
        setState(() => _selectedIds.remove(id));
        ref.read(cartNotifierProvider.notifier).removeFromCart(id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Item dihapus dari keranjang'),
          backgroundColor: Color(0xFF9098B1),
          behavior: SnackBarBehavior.floating,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            SizedBox(
              width: 24,
              child: Checkbox(
                value: isSelected,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      _selectedIds.add(id);
                    } else {
                      _selectedIds.remove(id);
                    }
                  });
                },
                activeColor: const Color(0xFF5A72C6),
              ),
            ),
            const SizedBox(width: 12),

            // Product icon
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: const Color(0xFFF0F2F8),
                child: const Icon(Icons.description_rounded,
                    color: Color(0xFF6B7FD7), size: 28),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF5A72C6).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Digital',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5A72C6))),
                  ),
                  const SizedBox(height: 4),
                  Text('Produk Digital',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF2A2A2A)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(_formatRupiah(harga),
                      style: const TextStyle(
                          color: Color(0xFF5A72C6),
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  Text('Jumlah: $jumlah',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9098B1))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF5A72C6).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                size: 48, color: Color(0xFF5A72C6)),
          ),
          const SizedBox(height: 20),
          const Text('Keranjang masih kosong',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2A2A2A))),
          const SizedBox(height: 8),
          const Text('Tambahkan produk dari halaman Explore',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: Color(0xFF9098B1), height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(double total, int totalItems) {
    final selectedItems = ref
        .read(cartItemsProvider)
        .whenData((items) =>
            items.where((e) => _selectedIds.contains(e.id)).toList())
        .valueOrNull;

    final selectedTotal = selectedItems?.fold<double>(
            0.0, (sum, item) => sum + item.subtotal) ??
        0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: _isSelectAll,
                  onChanged: (v) {
                    setState(() {
                      _isSelectAll = v ?? false;
                      final items = ref
                          .read(cartItemsProvider)
                          .valueOrNull ?? [];
                      if (_isSelectAll) {
                        _selectedIds
                            .addAll(items.map((e) => e.id));
                      } else {
                        _selectedIds.clear();
                      }
                    });
                  },
                  activeColor: const Color(0xFF5A72C6),
                ),
                const Text('Pilih Semua',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_selectedIds.isNotEmpty)
                      Text('${_selectedIds.length} item dipilih',
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF9098B1))),
                    Text(_formatRupiah(selectedTotal),
                        style: const TextStyle(
                            color: Color(0xFF5A72C6),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A72C6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_selectedIds.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Pilih minimal satu produk untuk checkout!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.redAccent,
                    ));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CheckoutScreen()));
                  }
                },
                child: const Text('Checkout',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}