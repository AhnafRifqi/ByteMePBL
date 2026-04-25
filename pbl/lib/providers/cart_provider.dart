import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/keranjang_model.dart';
import '../models/detail_keranjang_model.dart';
import '../services/keranjang_service.dart';

final keranjangServiceProvider = Provider((ref) => KeranjangService());

final myCartProvider = FutureProvider<KeranjangModel?>((ref) async {
  return await ref.read(keranjangServiceProvider).getMyCart();
});

final cartItemsProvider = FutureProvider<List<DetailKeranjangModel>>((
  ref,
) async {
  return await ref.read(keranjangServiceProvider).getCartItems();
});

final cartTotalProvider = FutureProvider<double>((ref) async {
  final items = await ref.watch(cartItemsProvider.future);
  return items.fold<double>(0.0, (sum, item) => sum + item.subtotal);
});

class CartNotifier extends StateNotifier<AsyncValue<void>> {
  final KeranjangService _keranjangService;
  final Ref _ref;

  CartNotifier(this._keranjangService, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> addToCart(
    String produkId,
    int jumlah,
    double hargaSatuan,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _keranjangService.addToCart(produkId, jumlah, hargaSatuan),
    );

    // Refresh cart items
    _ref.refresh(cartItemsProvider); // ignore: unused_result
  }

  Future<void> updateCartItem(String detailKeranjangId, int jumlah) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _keranjangService.updateCartItem(detailKeranjangId, jumlah),
    );

    _ref.refresh(cartItemsProvider); // ignore: unused_result
  }

  Future<void> removeFromCart(String detailKeranjangId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _keranjangService.removeFromCart(detailKeranjangId),
    );

    _ref.refresh(cartItemsProvider); // ignore: unused_result
  }

  Future<void> clearCart() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _keranjangService.clearCart());

    _ref.refresh(cartItemsProvider); // ignore: unused_result
  }
}

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, AsyncValue<void>>((ref) {
      final keranjangService = ref.watch(keranjangServiceProvider);
      return CartNotifier(keranjangService, ref);
    });
