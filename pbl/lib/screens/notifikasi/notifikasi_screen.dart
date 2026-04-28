import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/notification_provider.dart';
import '../../models/notifikasi_model.dart';

// ============================================================
// NOTIFIKASI SCREEN - Polished UI (standalone file)
// Path: pbl/lib/screens/notifikasi/notifikasi_screen.dart
// ============================================================

class NotifikasiScreen extends ConsumerWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(myNotificationsProvider);
    final unreadCount = ref.watch(unreadCountProvider);

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
            const Text('Notifikasi',
                style: TextStyle(
                    color: Color(0xFF1A1D2E),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(width: 8),
            unreadCount.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (count) => count > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFF4D67),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('$count',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => ref
                .read(notificationNotifierProvider.notifier)
                .markAllAsRead(),
            child: const Text('Tandai semua',
                style: TextStyle(
                    color: Color(0xFF6B7FD7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: notifications.when(
        loading: () => _buildLoadingList(),
        error: (err, _) => _buildErrorState(ref),
        data: (notifList) {
          if (notifList.isEmpty) return _buildEmptyState();

          final unread =
              notifList.where((n) => n.status == 'belum_dibaca').toList();
          final read =
              notifList.where((n) => n.status == 'dibaca').toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── BELUM DIBACA ──
              if (unread.isNotEmpty) ...[
                _sectionHeader('Belum Dibaca', unread.length,
                    color: const Color(0xFF6B7FD7)),
                const SizedBox(height: 10),
                ...unread.map((n) =>
                    _buildNotifCard(context, ref, n, isUnread: true)),
                const SizedBox(height: 20),
              ],

              // ── SUDAH DIBACA ──
              if (read.isNotEmpty) ...[
                _sectionHeader('Sebelumnya', read.length),
                const SizedBox(height: 10),
                ...read.map((n) =>
                    _buildNotifCard(context, ref, n, isUnread: false)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title, int count,
      {Color color = const Color(0xFF9098B1)}) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D2E))),
        const SizedBox(width: 6),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('$count',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ),
      ],
    );
  }

  Widget _buildNotifCard(
    BuildContext context,
    WidgetRef ref,
    NotifikasiModel notif, {
    required bool isUnread,
  }) {
    final isSanksi = notif.sanksiId != null;

    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(16)),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 22),
            SizedBox(height: 2),
            Text('Hapus',
                style: TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
      onDismissed: (_) => ref
          .read(notificationNotifierProvider.notifier)
          .deleteNotification(notif.id),
      child: GestureDetector(
        onTap: () {
          if (isUnread) {
            ref
                .read(notificationNotifierProvider.notifier)
                .markAsRead(notif.id);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUnread
                ? const Color(0xFF6B7FD7).withOpacity(0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isUnread
                ? Border.all(
                    color: const Color(0xFF6B7FD7).withOpacity(0.2),
                    width: 1)
                : Border.all(
                    color: Colors.transparent, width: 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSanksi
                      ? Colors.orange.withOpacity(0.12)
                      : isUnread
                          ? const Color(0xFF6B7FD7).withOpacity(0.12)
                          : const Color(0xFFF0F2F8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSanksi
                      ? Icons.warning_amber_rounded
                      : isUnread
                          ? Icons.notifications_rounded
                          : Icons.notifications_none_rounded,
                  color: isSanksi
                      ? Colors.orange
                      : isUnread
                          ? const Color(0xFF6B7FD7)
                          : const Color(0xFF9098B1),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label type
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isSanksi
                            ? Colors.orange.withOpacity(0.12)
                            : const Color(0xFF6B7FD7)
                                .withOpacity(0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isSanksi ? 'Peringatan Akun' : 'Informasi',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isSanksi
                                ? Colors.orange
                                : const Color(0xFF6B7FD7),
                            letterSpacing: 0.3),
                      ),
                    ),
                    Text(
                      notif.catatan,
                      style: TextStyle(
                          fontWeight: isUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 13,
                          color: const Color(0xFF1A1D2E),
                          height: 1.5),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _timeAgo(notif.createdAt),
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9098B1)),
                    ),
                  ],
                ),
              ),

              // Unread dot
              if (isUnread)
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 8),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Color(0xFF6B7FD7),
                        shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return DateFormat('dd MMM yyyy').format(time);
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Container(
        height: 80,
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
          Text('Gagal memuat notifikasi',
              style: TextStyle(
                  color: Colors.grey.shade500, fontSize: 15)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => ref.refresh(myNotificationsProvider),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B7FD7),
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
                color: const Color(0xFF6B7FD7).withOpacity(0.08),
                shape: BoxShape.circle),
            child: const Icon(Icons.notifications_none_rounded,
                size: 48, color: Color(0xFF6B7FD7)),
          ),
          const SizedBox(height: 20),
          const Text('Tidak ada notifikasi',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1D2E))),
          const SizedBox(height: 8),
          const Text('Notifikasi baru akan muncul di sini',
              style: TextStyle(fontSize: 13, color: Color(0xFF9098B1))),
        ],
      ),
    );
  }
}