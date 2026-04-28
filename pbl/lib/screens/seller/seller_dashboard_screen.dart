import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../produk/add_produk_screen.dart';
import '../produk/list_produk_screen.dart';
import '../notifikasi/notifikasi_screen.dart';

// ============================================================
// SELLER DASHBOARD SCREEN - Polished UI
// File baru: pbl/lib/screens/seller/seller_dashboard_screen.dart
// ============================================================

class SellerDashboardScreen extends ConsumerStatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  ConsumerState<SellerDashboardScreen> createState() =>
      _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends ConsumerState<SellerDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _DashboardContent(),
      const ListProdukScreen(isEmbedded: true),
      const _OrderContent(),
      const _SellerProfileContent(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8F0),
      body: pages[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF6B7FD7),
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.home_rounded, size: 26),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.grid_view_rounded, size: 24),
              ),
              label: 'Produk',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.shopping_bag_outlined, size: 24),
              ),
              label: 'Pesanan',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.person_rounded, size: 26),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// ── DASHBOARD CONTENT ──
class _DashboardContent extends ConsumerWidget {
  const _DashboardContent();

  String _formatRupiah(double n) => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(n);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final products = ref.watch(allProductsProvider);
    final orders = ref.watch(myOrdersProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER ──
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D4270).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF3D4270),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat Datang,',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      currentUser.when(
                        loading: () => Container(
                          width: 120,
                          height: 14,
                          color: const Color(0xFFE8ECF4),
                        ),
                        error: (_, __) => const Text('Penjual'),
                        data: (user) => Text(
                          user?.username ?? 'Penjual',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1A1D2E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotifikasiScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF3D4270),
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── BALANCE CARD ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B7FD7), Color(0xFF8B90C1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B7FD7).withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Saldo',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Icon(
                        Icons.visibility_outlined,
                        color: Colors.white.withOpacity(0.5),
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    orders.when(
                      loading: () => '...',
                      error: (_, __) => 'Rp 0',
                      data: (list) {
                        final total = list
                            .where((o) => o.status == 'selesai')
                            .fold<double>(0, (sum, o) => sum + o.totalHarga);
                        return _formatRupiah(total);
                      },
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Siap Dicairkan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                          const Text(
                            'Hubungi Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6B7FD7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Cairkan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── STAT CARDS ──
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    label: 'Total Penjualan',
                    value: orders.when(
                      loading: () => '...',
                      error: (_, __) => '0',
                      data: (list) => list
                          .where((o) => o.status == 'selesai')
                          .length
                          .toString(),
                    ),
                    icon: Icons.shopping_bag_outlined,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _statCard(
                    label: 'Total Produk',
                    value: products.when(
                      loading: () => '...',
                      error: (_, __) => '0',
                      data: (list) => list.length.toString(),
                    ),
                    icon: Icons.inventory_2_outlined,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _statCard(
                    label: 'Menunggu',
                    value: orders.when(
                      loading: () => '...',
                      error: (_, __) => '0',
                      data: (list) => list
                          .where((o) => o.status == 'menunggu')
                          .length
                          .toString(),
                    ),
                    icon: Icons.schedule_rounded,
                    color: const Color(0xFFFF9800),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── QUICK ACTION ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aksi Cepat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1D2E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _quickAction(
                    context,
                    icon: Icons.add_box_outlined,
                    label: 'Tambah\nProduk',
                    color: const Color(0xFF6B7FD7),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddProdukScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickAction(
                    context,
                    icon: Icons.list_alt_rounded,
                    label: 'Kelola\nProduk',
                    color: const Color(0xFF4CAF50),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ListProdukScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickAction(
                    context,
                    icon: Icons.bar_chart_rounded,
                    label: 'Laporan\nPenjualan',
                    color: const Color(0xFF9C27B0),
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickAction(
                    context,
                    icon: Icons.notifications_outlined,
                    label: 'Notifi\nkasi',
                    color: const Color(0xFFFF9800),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotifikasiScreen(),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── PRODUK TERBARU ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Produk Kamu',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1D2E),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: Color(0xFF6B7FD7),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            products.when(
              loading: () => Column(
                children: List.generate(
                  2,
                  (_) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8ECF4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              error: (_, __) =>
                  const Center(child: Text('Gagal memuat produk')),
              data: (list) {
                if (list.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'Belum ada produk.\nTambahkan produk pertamamu!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF9098B1),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: list.take(3).map((p) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F2F8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.description_rounded,
                              color: Color(0xFF6B7FD7),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Color(0xFF1A1D2E),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Rp ${p.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7FD7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Aktif',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              Icon(icon, size: 14, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D2E),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── ORDER CONTENT (Seller) ──
class _OrderContent extends ConsumerWidget {
  const _OrderContent();

  String _formatRupiah(double n) => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(n);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(myOrdersProvider);

    return SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pesanan Masuk',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1D2E),
                ),
              ),
            ),
          ),
          Expanded(
            child: orders.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF6B7FD7)),
              ),
              error: (_, __) =>
                  const Center(child: Text('Gagal memuat pesanan')),
              data: (list) {
                if (list.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 64,
                          color: Color(0xFFD0D5E8),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada pesanan masuk',
                          style: TextStyle(
                            color: Color(0xFF9098B1),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final order = list[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F2F8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              color: Color(0xFF6B7FD7),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#${order.id.substring(0, 8).toUpperCase()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF1A1D2E),
                                  ),
                                ),
                                Text(
                                  _formatRupiah(order.totalHarga),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7FD7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _statusBadge(order.status),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'selesai':
        color = const Color(0xFF4CAF50);
        break;
      case 'menunggu':
        color = const Color(0xFFFF9800);
        break;
      case 'dibatalkan':
        color = const Color(0xFFF44336);
        break;
      default:
        color = const Color(0xFF2196F3);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── SELLER PROFILE CONTENT ──
class _SellerProfileContent extends ConsumerWidget {
  const _SellerProfileContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Container(
      color: const Color(0xFF8B90C1),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF3D4270),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6B7FD7),
                          const Color(0xFF8B90C1),
                        ],
                      ),
                      border: Border.all(color: Colors.white30, width: 2),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: currentUser.when(
                      loading: () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 60,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                      error: (_, __) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Toko Anda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Penjual',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      data: (user) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.username ?? 'Toko Anda',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              user?.roleLabel ?? 'Penjual',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _menuItem(
                      context,
                      Icons.inventory_2_outlined,
                      'Kelola Produk',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ListProdukScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _menuItem(
                      context,
                      Icons.add_box_outlined,
                      'Tambah Produk',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProdukScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _menuItem(
                      context,
                      Icons.notifications_outlined,
                      'Notifikasi',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotifikasiScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _menuItem(
                      context,
                      Icons.logout_rounded,
                      'Keluar',
                      () async {
                        await AuthService().logout();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      isRed: true,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'ByteMe — Seller',
                      style: TextStyle(
                        color: Color(0xFF3D4270),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isRed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F8),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isRed ? Colors.red.shade400 : const Color(0xFF3D4270),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isRed ? Colors.red.shade600 : const Color(0xFF2A2A2A),
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
