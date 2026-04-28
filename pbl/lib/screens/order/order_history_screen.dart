import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../models/pesanan_model.dart';

// ============================================================
// ORDER HISTORY SCREEN - Polished UI (standalone file)
// Path: pbl/lib/screens/order/order_history_screen.dart
// ============================================================

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  String _formatRupiah(double n) => NumberFormat.currency(
          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
      .format(n);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(myOrdersProvider);

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
        title: const Text('Riwayat Pesanan',
            style: TextStyle(
                color: Color(0xFF2A2A2A),
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(myOrdersProvider),
            icon: const Icon(Icons.refresh_rounded,
                color: Color(0xFF6B7FD7)),
          ),
        ],
      ),
      body: orders.when(
        loading: () => _buildLoadingList(),
        error: (err, _) => _buildErrorState(ref),
        data: (orderList) {
          if (orderList.isEmpty) return _buildEmptyState();

          // Pisah berdasarkan status
          final active = orderList
              .where((o) =>
                  o.status == 'menunggu' || o.status == 'diproses')
              .toList();
          final completed = orderList
              .where((o) =>
                  o.status == 'selesai' || o.status == 'dibatalkan')
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── ACTIVE ORDERS ──
              if (active.isNotEmpty) ...[
                _sectionHeader('Pesanan Aktif', active.length),
                const SizedBox(height: 10),
                ...active.map((o) => _buildOrderCard(context, o)),
                const SizedBox(height: 20),
              ],

              // ── COMPLETED ORDERS ──
              if (completed.isNotEmpty) ...[
                _sectionHeader('Riwayat', completed.length),
                const SizedBox(height: 10),
                ...completed.map((o) => _buildOrderCard(context, o)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title, int count) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1D2E))),
        const SizedBox(width: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF6B7FD7).withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('$count',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7FD7))),
        ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, PesananModel order) {
    final statusConfig = _statusConfig(order.status);
    final isActive = order.status == 'menunggu' ||
        order.status == 'diproses' ||
        order.status == 'dikirim';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/order-detail',
          arguments: order.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
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
        child: Column(
          children: [
            // Status header
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: (statusConfig['color'] as Color)
                    .withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(statusConfig['icon'] as IconData,
                      color: statusConfig['color'] as Color,
                      size: 16),
                  const SizedBox(width: 6),
                  Text(statusConfig['label'] as String,
                      style: TextStyle(
                          color: statusConfig['color'] as Color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                  const Spacer(),
                  Text(
                    DateFormat('dd MMM yyyy')
                        .format(order.tglPesanan),
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9098B1)),
                  ),
                ],
              ),
            ),

            // Order body
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.description_rounded,
                        color: Color(0xFF6B7FD7), size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1A1D2E)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatRupiah(order.totalHarga),
                          style: const TextStyle(
                              color: Color(0xFF5A72C6),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFFB0B8CC)),
                ],
              ),
            ),

            // Progress bar for active orders
            if (isActive)
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: _buildProgressBar(order.status),
              ),

            // Action button for completed
            if (order.status == 'selesai')
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(
                        context, '/review',
                        arguments: order.id),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFF5A72C6), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10),
                    ),
                    icon: const Icon(Icons.star_outline_rounded,
                        color: Color(0xFF5A72C6), size: 16),
                    label: const Text('Beri Ulasan',
                        style: TextStyle(
                            color: Color(0xFF5A72C6),
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String status) {
    final steps = ['menunggu', 'diproses', 'dikirim', 'selesai'];
    final current = steps.indexOf(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 12, color: Color(0xFFF0F2F8)),
        Row(
          children: steps.asMap().entries.map((e) {
            final i = e.key;
            final isDone = i <= current;
            final isLast = i == steps.length - 1;
            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isDone
                          ? const Color(0xFF5A72C6)
                          : const Color(0xFFE8ECF4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i < current
                            ? const Color(0xFF5A72C6)
                            : const Color(0xFFE8ECF4),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 4),
        Text(
          _statusConfig(status)['label'] as String,
          style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF5A72C6),
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: const Color(0xFFE8ECF4),
            borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Center(
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
            onPressed: () => ref.refresh(myOrdersProvider),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A72C6),
                foregroundColor: Colors.white),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
            child: const Icon(Icons.receipt_long_outlined,
                size: 48, color: Color(0xFF5A72C6)),
          ),
          const SizedBox(height: 20),
          const Text('Belum ada pesanan',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2A2A2A))),
          const SizedBox(height: 8),
          const Text(
            'Pesanan yang kamu buat\nakan muncul di sini',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                color: Color(0xFF9098B1),
                height: 1.6),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _statusConfig(String status) {
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
          'label': 'Selesai',
          'icon': Icons.check_circle_outline_rounded,
          'color': const Color(0xFF4CAF50),
        };
      case 'dibatalkan':
        return {
          'label': 'Dibatalkan',
          'icon': Icons.cancel_outlined,
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