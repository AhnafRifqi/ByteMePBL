import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeninjauanScreen extends StatelessWidget {
  const PeninjauanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin - Peninjauan'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        // Query ini melakukan JOIN ke tabel produk dan profiles
        future: Supabase.instance.client
            .from('peninjauan')
            .select('*, produk(nama_produk, user_id), profiles(username)')
            .eq('status', 'proses'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data as List<dynamic>?;

          if (data == null || data.isEmpty) {
            return const Center(
              child: Text('Tidak ada laporan produk bermasalah.'),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final item = data[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    item['produk']['nama_produk'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Dilaporkan oleh: ${item['profiles']['username']}\nAlasan: ${item['catatan']}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) async {
                      if (action == 'hapus') {
                        // Action: Selesaikan peninjauan dan beri sanksi (otomatis hapus produk karena trigger RLS/status)
                        await Supabase.instance.client
                            .from('sanksi_akun')
                            .insert({
                              'peninjauan_id': item['peninjauan_id'],
                              'user_id': item['produk']['user_id'],
                              'jenis': 'peringatan',
                              'alasan': item['catatan'],
                            });
                        // Refresh halaman
                        (context as Element).markNeedsBuild();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'hapus',
                        child: Text(
                          'Beri Peringatan & Turunkan Produk',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'abaikan',
                        child: Text('Abaikan Laporan'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
