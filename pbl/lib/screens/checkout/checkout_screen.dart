import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/pembayaran_service.dart';

// ============================================================
// CHECKOUT SCREEN - Polished UI
// Menggantikan: pbl/lib/screens/checkout/checkout_screen.dart
// ============================================================

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String? _selectedMethod;
  final _pembayaranService = PembayaranService();

  String _formatRupiah(double number) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(number);
  }

  static const List<Map<String, dynamic>> _paymentMethods = [
    {
      'key': 'transfer',
      'label': 'Transfer Bank',
      'icon': Icons.account_balance_outlined,
      'subtitle': 'BCA, Mandiri, BRI, BNI'
    },
    {
      'key': 'ewallet',
      'label': 'E-Wallet',
      'icon': Icons.account_balance_wallet_outlined,
      'subtitle': 'GoPay, OVO, DANA, ShopeePay'
    },
    {
      'key': 'kartu_kredit',
      'label': 'Kartu Kredit',
      'icon': Icons.credit_card_outlined,
      'subtitle': 'Visa, Mastercard'
    },
    {
      'key': 'qris',
      'label': 'QRIS',
      'icon': Icons.qr_code_scanner_rounded,
      'subtitle': 'Scan QR untuk bayar'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFFE8E8F0),
              borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text('Checkout',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── PROFIL SECTION ──
            currentUser.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (user) => _buildProfileCard(user?.username ?? 'Pengguna'),
            ),
            const SizedBox(height: 16),

            // ── ORDER LIST ──
            cartItems.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFF5A72C6))),
              error: (_, __) => const SizedBox(),
              data: (items) => _buildOrderList(items),
            ),
            const SizedBox(height: 16),

            // ── PAYMENT METHOD ──
            _buildPaymentSection(),
            const SizedBox(height: 16),

            // ── TOTAL ──
            cartTotal.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (total) => _buildTotalCard(total),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: cartTotal.when(
        loading: () => const SizedBox(height: 80),
        error: (_, __) => const SizedBox(height: 80),
        data: (total) => _buildBottomButton(total),
      ),
    );
  }

  Widget _buildProfileCard(String username) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.account_circle_outlined,
              size: 40, color: Color(0xFF3D4270)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const Text('Pembeli',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildOrderList(List items) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(children: [
              Icon(Icons.list_alt_rounded, size: 20),
              SizedBox(width: 8),
              Text('Ringkasan Pesanan',
                  style: TextStyle(fontWeight: FontWeight.bold))
            ]),
          ),
          const Divider(height: 1),
          ...items.map((item) => ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F8),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.description_rounded,
                      color: Color(0xFF6B7FD7), size: 22),
                ),
                title: Text('Produk Digital',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Rp ${item.hargaSatuan.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5A72C6),
                        fontWeight: FontWeight.bold)),
                trailing: Text('${item.jumlah}x'),
              )),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Metode Pembayaran',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          ..._paymentMethods.map((m) => _buildPaymentOption(m)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(Map<String, dynamic> method) {
    final isSelected = _selectedMethod == method['key'];
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method['key']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3D4270).withOpacity(0.06)
              : const Color(0xFFF8F9FC),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3D4270)
                : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF3D4270).withOpacity(0.12)
                    : const Color(0xFFE8E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(method['icon'] as IconData,
                  color: const Color(0xFF3D4270), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method['label'],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: const Color(0xFF1A1D2E))),
                  Text(method['subtitle'],
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9098B1))),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? const Color(0xFF3D4270)
                  : const Color(0xFFD0D5E8),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(double total) {
    final serviceFee = 2000.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _detailRow('Subtotal', _formatRupiah(total)),
          _detailRow('Biaya Layanan', _formatRupiah(serviceFee)),
          const Divider(height: 20),
          _detailRow('Total Pembayaran',
              _formatRupiah(total + serviceFee),
              isBold: true),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold
                      ? FontWeight.bold
                      : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold
                      ? const Color(0xFF3D4270)
                      : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildBottomButton(double total) {
    final serviceFee = 2000.0;
    final grandTotal = total + serviceFee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D4270),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () => _processCheckout(grandTotal),
            child: const Text('Buat Pesanan',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Future<void> _processCheckout(double total) async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih metode pembayaran terlebih dahulu!'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    try {
      final cartItems = await ref.read(cartItemsProvider.future);
      final items = cartItems
          .map((item) => {
                'produk_id': item.produkId,
                'jumlah': item.jumlah,
                'harga_satuan': item.hargaSatuan,
              })
          .toList();

      final pesananId = await ref
          .read(orderNotifierProvider.notifier)
          .createOrder(items, total);

      if (pesananId != null) {
        await _pembayaranService.createPayment(pesananId, _selectedMethod!);
        await ref.read(cartNotifierProvider.notifier).clearCart();

        if (mounted) {
          // Tampilkan dialog sukses
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF4CAF50).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF4CAF50), size: 40),
                    ),
                    const SizedBox(height: 16),
                    const Text('Pesanan Berhasil!',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      'Pesanan kamu telah berhasil dibuat.\nSilakan selesaikan pembayaran.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D4270),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pushReplacementNamed(
                              context, '/order-history');
                        },
                        child: const Text('Lihat Pesanan',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal membuat pesanan: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }
}