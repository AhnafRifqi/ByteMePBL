import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/review_service.dart';

// ============================================================
// REVIEW PRODUCT SCREEN - Polished UI
// Menggantikan: pbl/lib/screens/review/review_product_screen.dart
// ============================================================

class ReviewProductScreen extends ConsumerStatefulWidget {
  final String produkId;
  const ReviewProductScreen({super.key, required this.produkId});

  @override
  ConsumerState<ReviewProductScreen> createState() =>
      _ReviewProductScreenState();
}

class _ReviewProductScreenState
    extends ConsumerState<ReviewProductScreen>
    with SingleTickerProviderStateMixin {
  int _rating = 0;
  final _komentarCtrl = TextEditingController();
  bool _isLoading = false;
  bool _submitted = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  static const List<String> _ratingLabels = [
    '',
    'Sangat Buruk',
    'Kurang Memuaskan',
    'Cukup',
    'Bagus',
    'Luar Biasa!',
  ];

  static const List<Color> _ratingColors = [
    Colors.transparent,
    Color(0xFFFF4D67),
    Color(0xFFFF8C42),
    Color(0xFFFFB800),
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim =
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _komentarCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih rating terlebih dahulu'),
        backgroundColor: Color(0xFFFF4D67),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ReviewService().createReview(
        widget.produkId,
        _rating,
        _komentarCtrl.text.isEmpty ? null : _komentarCtrl.text,
      );
      if (!mounted) return;
      setState(() => _submitted = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal mengirim ulasan: $e'),
          backgroundColor: const Color(0xFFFF4D67),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFFF0F2F8),
              borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF1A1D2E), size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text('Beri Ulasan',
            style: TextStyle(
                color: Color(0xFF1A1D2E),
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: _submitted ? _buildSuccessState() : _buildFormState(),
      ),
    );
  }

  // ── SUCCESS STATE ──
  Widget _buildSuccessState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.5, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              builder: (_, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF4CAF50), size: 52),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Ulasan Terkirim!',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D2E))),
            const SizedBox(height: 10),
            const Text(
              'Terima kasih sudah memberikan ulasan.\nPendapatmu sangat membantu pembeli lain.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9098B1),
                  height: 1.6),
            ),
            const SizedBox(height: 32),

            // Rating yang diberikan
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5,
                  (i) => Icon(
                        i < _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: const Color(0xFFFFB800),
                        size: 32,
                      )),
            ),
            const SizedBox(height: 8),
            Text(
              _ratingLabels[_rating],
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _ratingColors[_rating]),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B7FD7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Kembali ke Pesanan',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── FORM STATE ──
  Widget _buildFormState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product preview
          Container(
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
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.description_rounded,
                      color: Color(0xFF6B7FD7), size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Produk Digital',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1A1D2E))),
                      SizedBox(height: 4),
                      Text('Bagaimana pengalamanmu?',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9098B1))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Star rating
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                const Text('Beri Rating',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D2E))),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final starIdx = i + 1;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _rating = starIdx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          i < _rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: i < _rating
                              ? const Color(0xFFFFB800)
                              : const Color(0xFFD0D5E8),
                          size: 44,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _rating > 0
                      ? Text(
                          _ratingLabels[_rating],
                          key: ValueKey(_rating),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _ratingColors[_rating],
                          ),
                        )
                      : const Text(
                          'Ketuk bintang untuk memberi rating',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9098B1)),
                        ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Komentar
          Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('Komentar',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1D2E))),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F8),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('Opsional',
                        style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9098B1),
                            fontWeight: FontWeight.w500)),
                  ),
                ]),
                const SizedBox(height: 12),
                TextField(
                  controller: _komentarCtrl,
                  maxLines: 5,
                  maxLength: 500,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF1A1D2E)),
                  decoration: InputDecoration(
                    hintText:
                        'Ceritakan pengalamanmu menggunakan produk ini...',
                    hintStyle: const TextStyle(
                        color: Color(0xFFB0B8CC), fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF8F9FC),
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFFE8ECF4), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF6B7FD7), width: 1.5)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B7FD7),
                disabledBackgroundColor:
                    const Color(0xFF6B7FD7).withOpacity(0.6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : const Text('Kirim Ulasan',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}