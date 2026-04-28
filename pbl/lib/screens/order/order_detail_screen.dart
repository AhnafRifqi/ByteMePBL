import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';

// ============================================================
// ORDER DETAIL SCREEN - Polished UI
// Menggantikan: pbl/lib/screens/order/order_detail_screen.dart
// ============================================================

class OrderDetailScreen extends ConsumerWidget {
  final String pesananId;
  const OrderDetailScreen({super.key, required this.pesananId});

  String _formatRupiah(double n) => NumberFormat.currency(
          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
      .format(n);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdProvider(pesananId));
    final details = ref.watch(orderDetailsProvider(pesananId));

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
                color: Color(0xFF2A2A2A), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text('Detail Pesanan',
            style: TextStyle(
                color: Color(0xFF2A2A2A),
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      body: order.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF5A72C6))),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text('Gagal memuat pesanan',
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 15)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(orderByIdProvider(pesananId)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A72C6),
                    foregroundColor: Colors.white),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (orderData) {
          if (orderData == null) {
            return const Center(child: Text('Pesanan tidak ditemukan'));
          }

          final statusConfig = _getStatusConfig(orderData.status);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── STATUS CARD ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (statusConfig['color'] as Color).withOpacity(0.85),
                        (statusConfig['color'] as Color),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: (statusConfig['color'] as Color)
                              .withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(statusConfig['icon'] as IconData,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(statusConfig['label'] as String,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                  .format(orderData.tglPesanan),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── ORDER ID CARD ──
                _buildCard(
                  child: Column(
                    children: [
                      _infoRow(
                        icon: Icons.receipt_long_outlined,
                        label: 'Nomor Pesanan',
                        value:
                            '#${orderData.id.substring(0, 8).toUpperCase()}',
                        valueStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A72C6),
                            letterSpacing: 1),
                      ),
                      const Divider(
                          height: 20, color: Color(0xFFF0F2F8)),
                      _infoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tanggal Pesanan',
                        value: DateFormat('dd MMM yyyy, HH:mm')
                            .format(orderData.tglPesanan),
                      ),
                      const Divider(
                          height: 20, color: Color(0xFFF0F2F8)),
                      _infoRow(
                        icon: Icons.payments_outlined,
                        label: 'Total Pembayaran',
                        value: _formatRupiah(orderData.totalHarga),
                        valueStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1D2E)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── DETAIL PRODUK ──
                details.when(
                  loading: () => _buildCard(
                    child: Column(
                      children: List.generate(
                          2,
                          (_) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFE8ECF4),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: 12,
                                              width: 140,
                                              color:
                                                  const Color(0xFFE8ECF4)),
                                          const SizedBox(height: 6),
                                          Container(
                                              height: 10,
                                              width: 80,
                                              color:
                                                  const Color(0xFFE8ECF4)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ),
                  ),
                  error: (_, __) => const SizedBox(),
                  data: (detailList) => _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Icon(Icons.shopping_bag_outlined,
                              size: 18, color: Color(0xFF3D4270)),
                          SizedBox(width: 8),
                          Text('Produk Dipesan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1A1D2E))),
                        ]),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0xFFF0F2F8)),
                        ...detailList.map((detail) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F2F8),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                        Icons.description_rounded,
                                        color: Color(0xFF6B7FD7),
                                        size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Produk Digital',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                color: Color(0xFF1A1D2E))),
                                        const SizedBox(height: 2),
                                        Text(
                                            '${detail.jumlah}x • ${_formatRupiah(detail.hargaSatuan)}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF9098B1))),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    _formatRupiah(detail.subtotal),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF5A72C6)),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── TIMELINE STATUS ──
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [
                        Icon(Icons.timeline_rounded,
                            size: 18, color: Color(0xFF3D4270)),
                        SizedBox(width: 8),
                        Text('Status Pesanan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF1A1D2E))),
                      ]),
                      const SizedBox(height: 16),
                      _buildTimeline(orderData.status),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── ACTION: Review jika selesai ──
                if (orderData.status == 'selesai')
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                          context, '/review',
                          arguments: pesananId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A72C6),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.star_outline_rounded),
                      label: const Text('Beri Ulasan Produk',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),

                // ── ACTION: Batalkan jika masih menunggu ──
                if (orderData.status == 'menunggu')
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(context, ref),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFFFF4D67), width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.cancel_outlined,
                          color: Color(0xFFFF4D67)),
                      label: const Text('Batalkan Pesanan',
                          style: TextStyle(
                              color: Color(0xFFFF4D67),
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF5A72C6).withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Icon(icon, color: const Color(0xFF5A72C6), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF9098B1))),
              const SizedBox(height: 2),
              Text(value,
                  style: valueStyle ??
                      const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1D2E))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(String currentStatus) {
    final steps = [
      {'status': 'menunggu', 'label': 'Menunggu Pembayaran'},
      {'status': 'diproses', 'label': 'Sedang Diproses'},
      {'status': 'dikirim', 'label': 'Sedang Dikirim'},
      {'status': 'selesai', 'label': 'Selesai'},
    ];

    final statusOrder = [
      'menunggu',
      'diproses',
      'dikirim',
      'selesai'
    ];
    final currentIdx = statusOrder.indexOf(currentStatus);

    if (currentStatus == 'dibatalkan') {
      return Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFFF4D67),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close_rounded,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          const Text('Pesanan Dibatalkan',
              style: TextStyle(
                  color: Color(0xFFFF4D67),
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ],
      );
    }

    return Column(
      children: steps.asMap().entries.map((entry) {
        final idx = entry.key;
        final step = entry.value;
        final stepIdx = statusOrder.indexOf(step['status']!);
        final isDone = stepIdx <= currentIdx;
        final isCurrent = stepIdx == currentIdx;
        final isLast = idx == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDone
                        ? const Color(0xFF5A72C6)
                        : const Color(0xFFE8ECF4),
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(
                            color: const Color(0xFF5A72C6),
                            width: 3)
                        : null,
                  ),
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 28,
                    color: isDone
                        ? const Color(0xFF5A72C6)
                        : const Color(0xFFE8ECF4),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              child: Text(
                step['label']!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isCurrent
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: isDone
                      ? const Color(0xFF1A1D2E)
                      : const Color(0xFFB0B8CC),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    color: const Color(0xFFFF4D67).withOpacity(0.12),
                    shape: BoxShape.circle),
                child: const Icon(Icons.cancel_outlined,
                    color: Color(0xFFFF4D67), size: 32),
              ),
              const SizedBox(height: 16),
              const Text('Batalkan Pesanan?',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Pesanan yang sudah dibatalkan tidak bisa dikembalikan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFFE8ECF4)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('Tidak',
                          style:
                              TextStyle(color: Color(0xFF9098B1))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4D67),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await ref
                            .read(orderNotifierProvider.notifier)
                            .cancelOrder(pesananId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Pesanan berhasil dibatalkan'),
                            backgroundColor: Color(0xFF9098B1),
                            behavior: SnackBarBehavior.floating,
                          ));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Ya, Batalkan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'menunggu':
        return {
          'label': 'Menunggu Pembayaran',
          'icon': Icons.schedule_rounded,
          'color': const Color(0xFFFF9800),
        };
      case 'diproses':
        return {
          'label': 'Sedang Diproses',
          'icon': Icons.autorenew_rounded,
          'color': const Color(0xFF2196F3),
        };
      case 'dikirim':
        return {
          'label': 'Sedang Dikirim',
          'icon': Icons.local_shipping_outlined,
          'color': const Color(0xFF9C27B0),
        };
      case 'selesai':
        return {
          'label': 'Pesanan Selesai',
          'icon': Icons.check_circle_rounded,
          'color': const Color(0xFF4CAF50),
        };
      case 'dibatalkan':
        return {
          'label': 'Pesanan Dibatalkan',
          'icon': Icons.cancel_rounded,
          'color': const Color(0xFFF44336),
        };
      default:
        return {
          'label': status,
          'icon': Icons.info_outline_rounded,
          'color': const Color(0xFF9098B1),
        };
    }
  }
}