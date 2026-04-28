import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/product_model.dart';
import '../produk/add_produk_screen.dart';
import 'product_detail_screen.dart';

// ============================================================
// LIST PRODUK SCREEN - Polished Explore/Browse UI
// Menggantikan: pbl/lib/screens/produk/list_produk_screen.dart
// ============================================================

class ListProdukScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;
  const ListProdukScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<ListProdukScreen> createState() => _ListProdukScreenState();
}

class _ListProdukScreenState extends ConsumerState<ListProdukScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  String? _myRole;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.toLowerCase());
    });
    _checkRole();
  }

  Future<void> _checkRole() async {
    final role = await ref.read(myRoleProvider.future);
    if (mounted) setState(() => _myRole = role);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(allProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  if (!widget.isEmbedded)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Color(0xFF1A1D2E),
                        ),
                      ),
                    ),
                  const Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D2E),
                    ),
                  ),
                  const Spacer(),
                  products.when(
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                    data: (list) {
                      final filtered = _filterProducts(list);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B7FD7).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${filtered.length} Produk',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7FD7),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── SEARCH BAR ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.search,
                      color: Color(0xFF9098B1),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Cari produk digital...',
                          hintStyle: TextStyle(
                            color: Color(0xFF9098B1),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      GestureDetector(
                        onTap: () => _searchCtrl.clear(),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF9098B1),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── GRID ──
            Expanded(
              child: products.when(
                loading: () => _buildLoadingGrid(),
                error: (err, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal memuat produk',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref.refresh(allProductsProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B7FD7),
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
                data: (list) {
                  final filtered = _filterProducts(list);
                  if (filtered.isEmpty) return _buildEmptyState();
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.62,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) =>
                        _buildProductCard(filtered[i], ctx),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // FAB hanya untuk penjual
      floatingActionButton: _myRole == 'penjual'
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProdukScreen()),
                );
                // Refresh the products list
                final _ = await ref.refresh(allProductsProvider);
              },
              backgroundColor: const Color(0xFF6B7FD7),
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add),
              label: const Text(
                'Jual Produk',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          : null,
    );
  }

  List<ProductModel> _filterProducts(List<ProductModel> list) {
    if (_query.isEmpty) return list;
    return list
        .where(
          (p) =>
              p.name.toLowerCase().contains(_query) ||
              (p.description?.toLowerCase().contains(_query) ?? false),
        )
        .toList();
  }

  Widget _buildProductCard(ProductModel product, BuildContext context) {
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
                      child: const Center(
                        child: Icon(
                          Icons.description_rounded,
                          color: Color(0xFF6B7FD7),
                          size: 48,
                        ),
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
                            letterSpacing: 0.5,
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
                  if (product.description != null &&
                      product.description!.isNotEmpty)
                    Text(
                      product.description!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9098B1),
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
                      onPressed: () {},
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Produk tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9098B1),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Coba kata kunci lain',
            style: TextStyle(fontSize: 13, color: Color(0xFFB0B8CC)),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => _searchCtrl.clear(),
            child: const Text(
              'Reset pencarian',
              style: TextStyle(
                color: Color(0xFF6B7FD7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.62,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8ECF4),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
