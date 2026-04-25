import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/produk/list_produk_screen.dart';
import 'screens/produk/add_produk_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/order/order_history_screen.dart';
import 'screens/order/order_detail_screen.dart';
import 'screens/review/review_product_screen.dart';
import 'screens/notifikasi/notifikasi_screen.dart';
import 'screens/admin/peninjauan_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: '', // Replace with your URL
    anonKey: '', // Replace with your key
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByteMePBL',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/produk-list': (context) => const ListProdukScreen(),
        '/produk-add': (context) => const AddProdukScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/order-history': (context) => const OrderHistoryScreen(),
        '/notifikasi': (context) => const NotifikasiScreen(),
        '/admin-review': (context) => const PeninjaauanScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/order-detail') {
          final pesananId = settings.arguments as String?;
          if (pesananId != null) {
            return MaterialPageRoute(
              builder: (context) => OrderDetailScreen(pesananId: pesananId),
            );
          }
        }
        if (settings.name == '/review') {
          final produkId = settings.arguments as String?;
          if (produkId != null) {
            return MaterialPageRoute(
              builder: (context) => ReviewProductScreen(produkId: produkId),
            );
          }
        }
        return null;
      },
    );
  }
}
