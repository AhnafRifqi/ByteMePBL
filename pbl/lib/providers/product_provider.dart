import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

final productServiceProvider = Provider((ref) => ProductService());

final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  return await ref.read(productServiceProvider).getProducts();
});

final productByIdProvider = FutureProvider.family<ProductModel?, String>((
  ref,
  produkId,
) async {
  return await ref.read(productServiceProvider).getProductById(produkId);
});

class ProductNotifier extends StateNotifier<AsyncValue<void>> {
  final ProductService _productService;

  ProductNotifier(this._productService) : super(const AsyncValue.data(null));

  Future<void> addProduct(
    String nama,
    double harga,
    String deskripsi,
    String? filePath,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _productService.addProduct(nama, harga, deskripsi, filePath),
    );
  }

  Future<void> updateProduct(
    String produkId,
    String nama,
    double harga,
    String deskripsi,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // TODO: Implement update product
    });
  }

  Future<void> deleteProduct(String produkId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // TODO: Implement delete product
    });
  }
}

final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, AsyncValue<void>>((ref) {
      final productService = ref.watch(productServiceProvider);
      return ProductNotifier(productService);
    });
