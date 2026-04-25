import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotifikasiListener extends StatefulWidget {
  final Widget child;
  const NotifikasiListener({required this.child, super.key});

  @override
  State<NotifikasiListener> createState() => _NotifikasiListenerState();
}

class _NotifikasiListenerState extends State<NotifikasiListener> {
  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    Supabase.instance.client
        .from('notifikasi')
        .stream(primaryKey: ['notif_id'])
        .eq('user_id', user.id)
        .listen((data) {
          if (data.isNotEmpty && data.first['status'] == 'belum_dibaca') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(data.first['catatan']),
                backgroundColor: Colors.indigo,
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}