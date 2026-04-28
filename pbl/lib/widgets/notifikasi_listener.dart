import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ============================================================
// NOTIFIKASI LISTENER - Polished UI
// Path: pbl/lib/widgets/notifikasi_listener.dart
// Menampilkan snackbar polished saat notifikasi baru masuk
// ============================================================

class NotifikasiListener extends StatefulWidget {
  final Widget child;
  const NotifikasiListener({required this.child, super.key});

  @override
  State<NotifikasiListener> createState() => _NotifikasiListenerState();
}

class _NotifikasiListenerState extends State<NotifikasiListener> {
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    _channel = Supabase.instance.client
        .channel('notifikasi_${user.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifikasi',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: user.id,
          ),
          callback: (payload) {
            if (!mounted) return;
            final data = payload.newRecord;
            if (data['status'] == 'belum_dibaca') {
              _showPolishedSnackbar(
                context,
                catatan: data['catatan'] ?? 'Ada notifikasi baru',
                isSanksi: data['sanksi_id'] != null,
              );
            }
          },
        )
        .subscribe();
  }

  void _showPolishedSnackbar(
    BuildContext context, {
    required String catatan,
    required bool isSanksi,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(16),
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSanksi ? const Color(0xFFFF9800) : const Color(0xFF3D4270),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSanksi
                      ? Icons.warning_amber_rounded
                      : Icons.notifications_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isSanksi ? 'Peringatan Akun' : 'Notifikasi Baru',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      catatan,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
