import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ============================================================
// PENINJAUAN SCREEN (ADMIN) - Polished UI
// Menggantikan: pbl/lib/screens/admin/peninjauan_screen.dart
// ============================================================

class PeninjaauanScreen extends StatefulWidget {
  const PeninjaauanScreen({super.key});

  @override
  State<PeninjaauanScreen> createState() => _PeninjaauanScreenState();
}

class _PeninjaauanScreenState extends State<PeninjaauanScreen> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _future = Supabase.instance.client
          .from('peninjauan')
          .select('*, produk(nama_produk, user_id), profiles(username)')
          .eq('status', 'proses');
    });
  }

  Future<void> _beriPeringatan(Map<String, dynamic> item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.12),
                    shape: BoxShape.circle),
                child: const Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 32),
              ),
              const SizedBox(height: 16),
              const Text('Beri Peringatan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                  'Berikan peringatan kepada penjual "${item['profiles']['username']}" dan turunkan produk "${item['produk']['nama_produk']}"?',
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFFE8ECF4)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('Batal',
                          style: TextStyle(color: Color(0xFF9098B1))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Beri Peringatan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      try {
        await Supabase.instance.client.from('sanksi_akun').insert({
          'peninjauan_id': item['peninjauan_id'],
          'user_id': item['produk']['user_id'],
          'jenis': 'peringatan',
          'alasan': item['catatan'],
        });
        // Update status peninjauan
        await Supabase.instance.client
            .from('peninjauan')
            .update({'status': 'selesai'})
            .eq('peninjauan_id', item['peninjauan_id']);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Peringatan berhasil diberikan'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ));
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Gagal: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ));
        }
      }
    }
  }

  Future<void> _abaikan(Map<String, dynamic> item) async {
    try {
      await Supabase.instance.client
          .from('peninjauan')
          .update({'status': 'selesai'})
          .eq('peninjauan_id', item['peninjauan_id']);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Laporan diabaikan'),
          backgroundColor: Color(0xFF9098B1),
          behavior: SnackBarBehavior.floating,
        ));
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
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
        title: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8)),
              child: Text('ADMIN',
                  style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1)),
            ),
            const SizedBox(width: 10),
            const Text('Panel Peninjauan',
                style: TextStyle(
                    color: Color(0xFF1A1D2E),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded,
                color: Color(0xFF6B7FD7)),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFF6B7FD7)));
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('Gagal memuat data',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 15)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B7FD7),
                        foregroundColor: Colors.white),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.08),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle_outline_rounded,
                        size: 48, color: Color(0xFF4CAF50)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Tidak ada laporan aktif',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1D2E))),
                  const SizedBox(height: 8),
                  const Text('Semua laporan telah ditangani',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF9098B1))),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (ctx, i) {
              final item = data[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ]),
                child: Column(
                  children: [
                    // Header merah
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.flag_rounded,
                              color: Colors.red.shade400, size: 18),
                          const SizedBox(width: 8),
                          const Text('Laporan Masuk',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Produk
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF0F2F8),
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                child: const Icon(
                                    Icons.description_rounded,
                                    color: Color(0xFF6B7FD7), size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        item['produk']['nama_produk'] ??
                                            'Produk tidak diketahui',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Color(0xFF1A1D2E))),
                                    Text(
                                        'Penjual: ${item['profiles']['username'] ?? 'Anonim'}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9098B1))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Alasan
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Alasan Laporan:',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF9098B1))),
                                const SizedBox(height: 4),
                                Text(
                                    item['catatan'] ??
                                        'Tidak ada keterangan',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF1A1D2E))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _abaikan(item),
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Color(0xFFE8ECF4)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12)),
                                  child: const Text('Abaikan',
                                      style: TextStyle(
                                          color: Color(0xFF9098B1),
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      _beriPeringatan(item),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12)),
                                  child: const Text(
                                      'Beri Peringatan & Turunkan',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}