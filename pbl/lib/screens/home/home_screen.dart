import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/auth_service.dart';
import '../produk/product_detail_screen.dart';
import '../cart/cart_screen.dart';
import '../notifikasi/notifikasi_screen.dart';
import '../auth/login_screen.dart';
import '../produk/list_produk_screen.dart';

// ============================================================
// HOME SCREEN - ByteMe Digital Marketplace (Polished UI)
// Menggantikan: pbl/lib/screens/home/home_screen.dart
// ============================================================

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeContent(),
      const ListProdukScreen(isEmbedded: true),
      const CartScreen(isEmbedded: true),
      const _ProfileContent(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_rounded, 'Home'),
              _navItem(1, Icons.explore_rounded, 'Explore'),
              _navItem(2, Icons.shopping_bag_rounded, 'Cart'),
              _navItem(3, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6B7FD7).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF6B7FD7)
                  : const Color(0xFFB0B8CC),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF6B7FD7)
                    : const Color(0xFFB0B8CC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HOME CONTENT
// ============================================================
class _HomeContent extends ConsumerStatefulWidget {
  const _HomeContent();

  @override
  ConsumerState<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<_HomeContent> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  static const List<Map<String, dynamic>> _banners = [
    {
      'title': 'Get 30% off on UI Kits',
      'subtitle': 'Limited time offer',
      'gradient': [Color(0xFF7C8FE0), Color(0xFF9FB3F5)],
      'icon': Icons.dashboard_customize_rounded,
    },
    {
      'title': 'E-Book Terlaris Minggu Ini',
      'subtitle': 'Ratusan judul tersedia',
      'gradient': [Color(0xFF5E9EF5), Color(0xFF8FC3F9)],
      'icon': Icons.menu_book_rounded,
    },
    {
      'title': 'Canva Template Premium',
      'subtitle': 'Mulai dari Rp 25.000',
      'gradient': [Color(0xFFB07FD7), Color(0xFFD4A8F5)],
      'icon': Icons.auto_awesome_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_currentBanner + 1) % _banners.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final products = ref.watch(allProductsProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ── HEADER ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: currentUser.when(
                loading: () => _buildHeaderSkeleton(),
                error: (_, __) => _buildHeaderFallback(),
                data: (user) => _buildHeader(user?.username ?? 'Pengguna'),
              ),
            ),
          ),

          // ── BANNER ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _buildBanner(),
            ),
          ),

          // ── SECTION: PRODUK TERBARU ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: _buildSectionHeader('🔥 Produk Terbaru', onMore: () {}),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 240,
              child: products.when(
                loading: () => _buildHorizontalSkeleton(),
                error: (_, __) => const Center(
                  child: Text(
                    'Gagal memuat produk',
                    style: TextStyle(color: Color(0xFF9098B1)),
                  ),
                ),
                data: (productList) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: productList.take(5).length,
                  itemBuilder: (ctx, i) =>
                      _buildHorizontalCard(productList[i], ctx),
                ),
              ),
            ),
          ),

          // ── SECTION: SEMUA PRODUK ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: _buildSectionHeader('🔍 Semua Produk', onMore: () {}),
            ),
          ),

          products.when(
            loading: () => SliverToBoxAdapter(child: _buildGridSkeleton()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
            data: (productList) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _buildGridCard(productList[i], ctx),
                  childCount: productList.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.62,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader(String username) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFD0D5E8),
          child: const Icon(Icons.person, color: Color(0xFF6B7FD7), size: 28),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hi, ${username.split(' ').first}! ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1D2E),
                  ),
                ),
                const Text('🧡', style: TextStyle(fontSize: 18)),
              ],
            ),
            const Text(
              'Lagi cari apa?',
              style: TextStyle(fontSize: 13, color: Color(0xFF9098B1)),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotifikasiScreen()),
          ),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF6B7FD7),
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSkeleton() => Row(
    children: [
      CircleAvatar(radius: 24, backgroundColor: const Color(0xFFE8ECF4)),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFFE8ECF4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFFE8ECF4),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    ],
  );

  Widget _buildHeaderFallback() => _buildHeader('Pengguna');

  Widget _buildBanner() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemBuilder: (_, i) {
              final banner = _banners[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: List<Color>.from(banner['gradient']),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            banner['subtitle'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF6B7FD7),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('Shop Now'),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      banner['icon'],
                      color: Colors.white.withOpacity(0.3),
                      size: 80,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentBanner == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentBanner == i
                    ? const Color(0xFF6B7FD7)
                    : const Color(0xFFD0D5E8),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onMore}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1D2E),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onMore,
          child: const Row(
            children: [
              Text(
                'more',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7FD7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 2),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: Color(0xFF6B7FD7),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalCard(dynamic product, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(produkId: product.id),
        ),
      ),
      child: Container(
        width: 155,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFF0F2F8),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Color(0xFF6B7FD7),
                    size: 40,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7FD7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B7FD7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(dynamic product, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(produkId: product.id),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: const Color(0xFFF0F2F8),
                      child: const Icon(
                        Icons.description_rounded,
                        color: Color(0xFF6B7FD7),
                        size: 40,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B7FD7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Digital',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B7FD7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(dynamic product) {
    ref
        .read(cartNotifierProvider.notifier)
        .addToCart(product.id, 1, product.price);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ditambahkan ke keranjang!'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF6B7FD7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildHorizontalSkeleton() => ListView.builder(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemCount: 3,
    itemBuilder: (_, __) => Container(
      width: 155,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECF4),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  Widget _buildGridSkeleton() => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 0.62,
    ),
    itemCount: 4,
    itemBuilder: (_, __) => Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECF4),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

// ============================================================
// PROFILE CONTENT
// ============================================================
class _ProfileContent extends ConsumerWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Container(
      color: const Color(0xFF8B90C1),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFF3D4270),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
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
                      Icons.person,
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
                            width: 100,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 80,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                      error: (_, __) => const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengguna',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Pembeli',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      data: (user) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.username ?? 'Pengguna',
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
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              user?.roleLabel ?? 'Pembeli',
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

            // Menu
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Menu items berdasarkan role
                    currentUser.when(
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                      data: (user) {
                        final isBuyer = user?.role == 'pembeli';
                        final isAdmin = user?.role == 'admin';

                        return Column(
                          children: [
                            // Menu untuk pembeli
                            if (isBuyer) ...[
                              _menuItem(
                                context,
                                Icons.shopping_bag_outlined,
                                'Riwayat Pesanan',
                                () => Navigator.pushNamed(
                                  context,
                                  '/order-history',
                                ),
                              ),
                              const SizedBox(height: 12),
                              _menuItem(
                                context,
                                Icons.favorite_outline_rounded,
                                'Barang Favorit',
                                () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Fitur favorit sedang dikembangkan',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _menuItem(
                                context,
                                Icons.local_shipping_outlined,
                                'Lacak Pengiriman',
                                () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Fitur tracking sedang dikembangkan',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Menu notifikasi untuk semua
                            _menuItem(
                              context,
                              Icons.notifications_outlined,
                              'Notifikasi',
                              () => Navigator.pushNamed(context, '/notifikasi'),
                            ),
                            const SizedBox(height: 12),

                            // Menu admin
                            if (isAdmin)
                              Column(
                                children: [
                                  _menuItem(
                                    context,
                                    Icons.admin_panel_settings_outlined,
                                    'Panel Admin',
                                    () => Navigator.pushNamed(
                                      context,
                                      '/admin-review',
                                    ),
                                    isRed: true,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),

                            // Menu logout
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
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'ByteMe',
                      style: TextStyle(
                        color: Color(0xFF3D4270),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 1.2,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
