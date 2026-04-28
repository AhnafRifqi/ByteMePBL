import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';

// ============================================================
// PRODUCT DETAIL SCREEN - Polished UI
// File baru: pbl/lib/screens/produk/product_detail_screen.dart
// ============================================================

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String produkId;
  const ProductDetailScreen({super.key, required this.produkId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  bool _isDescExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productByIdProvider(widget.produkId));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: product.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF6B7FD7))),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text('Gagal memuat produk',
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 15)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B7FD7),
                    foregroundColor: Colors.white),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
        data: (prod) {
          if (prod == null) {
            return const Center(child: Text('Produk tidak ditemukan'));
          }
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildImageArea()),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(28)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(prod.name,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1A1D2E),
                                        height: 1.2)),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                  'Rp ${prod.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1A1D2E))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(
                              color: Color(0xFFF0F2F8), thickness: 1),
                          const SizedBox(height: 16),

                          // Description
                          const Text('Deskripsi',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1D2E))),
                          const SizedBox(height: 10),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 250),
                            crossFadeState: _isDescExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: Text(
                              prod.description ??
                                  'Tidak ada deskripsi untuk produk ini.',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7380),
                                  height: 1.6),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            secondChild: Text(
                              prod.description ??
                                  'Tidak ada deskripsi untuk produk ini.',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7380),
                                  height: 1.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => setState(() =>
                                _isDescExpanded = !_isDescExpanded),
                            child: Text(
                              _isDescExpanded
                                  ? 'Tampilkan lebih sedikit'
                                  : 'Selengkapnya >',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7FD7)),
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Divider(
                              color: Color(0xFFF0F2F8), thickness: 1),
                          const SizedBox(height: 16),

                          // Info detail
                          _buildInfoRow(Icons.inventory_2_outlined,
                              'Tipe Produk', 'Produk Digital'),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.download_outlined, 'Metode',
                              'Unduh setelah pembayaran'),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.verified_outlined,
                              'Garansi', 'Dijamin asli'),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Back button overlay
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 18, color: Color(0xFF1A1D2E)),
                  ),
                ),
              ),

              // Add to Cart button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    MediaQuery.of(context).padding.bottom + 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 16,
                          offset: const Offset(0, -4))
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(cartNotifierProvider.notifier)
                          .addToCart(prod.id, 1, prod.price);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${prod.name} ditambahkan ke keranjang!'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color(0xFF6B7FD7),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B7FD7),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    child: const Text('Tambah ke Keranjang'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageArea() {
    return Container(
      height: 300,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: const Color(0xFFF0F2F8),
          child: const Center(
            child: Icon(Icons.description_rounded,
                color: Color(0xFF6B7FD7), size: 80),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF6B7FD7).withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF6B7FD7), size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF9098B1))),
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1D2E))),
          ],
        ),
      ],
    );
  }
}