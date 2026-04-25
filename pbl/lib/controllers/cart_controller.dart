import 'package:flutter/foundation.dart';
import '../models/keranjang_model.dart';
import '../models/detail_keranjang_model.dart';
import '../services/keranjang_service.dart';

class CartController extends ChangeNotifier {
  final KeranjangService _keranjangService = KeranjangService();

  bool _isLoading = false;
  String? _error;
  KeranjangModel? _myCart;
  List<DetailKeranjangModel> _cartItems = [];
  double _total = 0.0;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  KeranjangModel? get myCart => _myCart;
  List<DetailKeranjangModel> get cartItems => _cartItems;
  double get total => _total;

  Future<void> fetchMyCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myCart = await _keranjangService.getMyCart();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCartItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cartItems = await _keranjangService.getCartItems();
      _calculateTotal();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(
    String produkId,
    int jumlah,
    double hargaSatuan,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _keranjangService.addToCart(produkId, jumlah, hargaSatuan);
      await fetchCartItems();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCartItem(String detailKeranjangId, int jumlah) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _keranjangService.updateCartItem(detailKeranjangId, jumlah);
      await fetchCartItems();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeFromCart(String detailKeranjangId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _keranjangService.removeFromCart(detailKeranjangId);
      await fetchCartItems();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> clearCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _keranjangService.clearCart();
      _cartItems = [];
      _total = 0.0;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void _calculateTotal() {
    _total = _cartItems.fold<double>(0.0, (sum, item) => sum + item.subtotal);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
