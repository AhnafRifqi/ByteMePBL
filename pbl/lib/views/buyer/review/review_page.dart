import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/review_service.dart';

class ReviewProductScreen extends ConsumerStatefulWidget {
  final String produkId;

  const ReviewProductScreen({Key? key, required this.produkId})
    : super(key: key);

  @override
  ConsumerState<ReviewProductScreen> createState() =>
      _ReviewProductScreenState();
}

class _ReviewProductScreenState extends ConsumerState<ReviewProductScreen> {
  int rating = 5;
  final komentarController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beri Review')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating Produk',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() => rating = index + 1);
                  },
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_outline,
                    color: Colors.amber,
                    size: 32,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            const Text(
              'Komentar (Opsional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: komentarController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tuliskan komentar Anda...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitReview,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Kirim Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    setState(() => isLoading = true);

    try {
      final reviewService = ReviewService();
      await reviewService.createReview(
        widget.produkId,
        rating,
        komentarController.text.isEmpty ? null : komentarController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review berhasil dikirim')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    komentarController.dispose();
    super.dispose();
  }
}
