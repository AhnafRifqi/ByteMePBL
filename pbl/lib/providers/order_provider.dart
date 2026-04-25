import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pesanan_model.dart';
import '../models/detail_pesanan_model.dart';
import '../services/pesanan_service.dart';

final pesananServiceProvider = Provider((ref) => PesananService());

final myOrdersProvider = FutureProvider<List<PesananModel>>((ref) async {
  return await ref.read(pesananServiceProvider).getMyOrders();
});

final orderByIdProvider = FutureProvider.family<PesananModel?, String>((
  ref,
  pesananId,
) async {
  return await ref.read(pesananServiceProvider).getOrderById(pesananId);
});

final orderDetailsProvider =
    FutureProvider.family<List<DetailPesananModel>, String>((
      ref,
      pesananId,
    ) async {
      return await ref.read(pesananServiceProvider).getOrderDetails(pesananId);
    });

class OrderNotifier extends StateNotifier<AsyncValue<void>> {
  final PesananService _pesananService;
  final Ref _ref;

  OrderNotifier(this._pesananService, this._ref)
    : super(const AsyncValue.data(null));

  Future<String?> createOrder(
    List<Map<String, dynamic>> items,
    double totalHarga,
  ) async {
    state = const AsyncValue.loading();
    String? pesananId;

    state = await AsyncValue.guard(() async {
      pesananId = await _pesananService.createOrder(items, totalHarga);
    });

    if (state is! AsyncError) {
      _ref.refresh(myOrdersProvider); // ignore: unused_result
    }

    return pesananId;
  }

  Future<void> cancelOrder(String pesananId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _pesananService.cancelOrder(pesananId),
    );

    _ref.refresh(myOrdersProvider); // ignore: unused_result
  }

  Future<void> updateOrderStatus(String pesananId, String status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _pesananService.updateOrderStatus(pesananId, status),
    );

    _ref.refresh(myOrdersProvider); // ignore: unused_result
    _ref.refresh(orderByIdProvider(pesananId)); // ignore: unused_result
  }
}

final orderNotifierProvider =
    StateNotifierProvider<OrderNotifier, AsyncValue<void>>((ref) {
      final pesananService = ref.watch(pesananServiceProvider);
      return OrderNotifier(pesananService, ref);
    });
