import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/notification_provider.dart';

class NotifikasiScreen extends ConsumerWidget {
  const NotifikasiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(myNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ref.read(notificationNotifierProvider.notifier).markAllAsRead();
            },
          ),
        ],
      ),
      body: notifications.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (notifList) {
          if (notifList.isEmpty) {
            return const Center(child: Text('Tidak ada notifikasi'));
          }

          return ListView.builder(
            itemCount: notifList.length,
            itemBuilder: (context, index) {
              final notif = notifList[index];
              return Dismissible(
                key: Key(notif.id),
                onDismissed: (direction) {
                  ref
                      .read(notificationNotifierProvider.notifier)
                      .deleteNotification(notif.id);
                },
                child: Card(
                  margin: const EdgeInsets.all(8),
                  color: notif.status == 'belum_dibaca'
                      ? Colors.blue.shade50
                      : Colors.white,
                  child: ListTile(
                    title: Text(
                      notif.catatan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      notif.createdAt.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: notif.status == 'belum_dibaca'
                        ? const Icon(Icons.circle, color: Colors.blue, size: 12)
                        : null,
                    onTap: () {
                      if (notif.status == 'belum_dibaca') {
                        ref
                            .read(notificationNotifierProvider.notifier)
                            .markAsRead(notif.id);
                      }
                    },
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
