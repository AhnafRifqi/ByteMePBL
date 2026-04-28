import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ── Auth ──
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

// ── Buyer ──
import 'screens/home/home_screen.dart';
import 'screens/produk/list_produk_screen.dart';
import 'screens/produk/add_produk_screen.dart';
import 'screens/produk/product_detail_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/order/order_history_screen.dart';
import 'screens/order/order_detail_screen.dart';
import 'screens/review/review_product_screen.dart';
import 'screens/notifikasi/notifikasi_screen.dart';

// ── Seller ──
import 'screens/seller/seller_dashboard_screen.dart';

// ── Admin ──
import 'screens/admin/peninjauan_screen.dart';

// ============================================================
// MAIN - ByteMe Digital Marketplace (pbl) — FINAL
// Semua screen menggunakan Polished UI bergaya chiquixs
// Backend: Supabase (tidak ada perubahan)
// ============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar transparan
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await Supabase.initialize(
    url: 'https://.supabase.co',    // ← Ganti dengan URL Supabase kamu
    anonKey: '',    // ← Ganti dengan Anon Key Supabase kamu
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByteMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B7FD7),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F2F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Color(0xFF1A1D2E),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFF1A1D2E)),
        ),
      ),

      // ── Halaman awal ──
      home: const _SplashRouter(),

      // ── Named routes ──
      routes: {
        '/login':           (ctx) => const LoginScreen(),
        '/register':        (ctx) => const RegisterScreen(),
        '/home':            (ctx) => const HomeScreen(),
        '/seller':          (ctx) => const SellerDashboardScreen(),
        '/produk-list':     (ctx) => const ListProdukScreen(),
        '/produk-add':      (ctx) => const AddProdukScreen(),
        '/cart':            (ctx) => const CartScreen(),
        '/checkout':        (ctx) => const CheckoutScreen(),
        '/order-history':   (ctx) => const OrderHistoryScreen(),
        '/notifikasi':      (ctx) => const NotifikasiScreen(),
        '/admin-review':    (ctx) => const PeninjaauanScreen(),
      },

      // ── Dynamic routes ──
      onGenerateRoute: (settings) {
        switch (settings.name) {

          // Order detail
          case '/order-detail': {
            final id = settings.arguments as String?;
            if (id != null) {
              return _route(OrderDetailScreen(pesananId: id));
            }
            break;
          }

          // Review produk
          case '/review': {
            final id = settings.arguments as String?;
            if (id != null) {
              return _route(ReviewProductScreen(produkId: id));
            }
            break;
          }

          // Product detail
          case '/produk-detail': {
            final id = settings.arguments as String?;
            if (id != null) {
              return _route(ProductDetailScreen(produkId: id));
            }
            break;
          }
        }
        return null;
      },
    );
  }

  MaterialPageRoute _route(Widget page) =>
      MaterialPageRoute(builder: (_) => page);
}

// ── Splash router: cek session Supabase ──
class _SplashRouter extends StatefulWidget {
  const _SplashRouter();

  @override
  State<_SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<_SplashRouter> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // Cek role untuk arahkan ke halaman yang tepat
    try {
      final data = await Supabase.instance.client
          .from('profiles')
          .select('role')
          .eq('id', session.user.id)
          .single();

      final role = data['role'] as String?;
      if (!mounted) return;

      if (role == 'penjual') {
        Navigator.pushReplacementNamed(context, '/seller');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (_) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF6B7FD7),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B7FD7).withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.storefront_rounded,
                  color: Colors.white, size: 48),
            ),
            const SizedBox(height: 20),
            const Text('ByteMe',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D2E),
                    letterSpacing: -0.5)),
            const SizedBox(height: 6),
            const Text('Digital Marketplace',
                style: TextStyle(
                    fontSize: 13, color: Color(0xFF9098B1))),
            const SizedBox(height: 48),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: Color(0xFF6B7FD7),
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}