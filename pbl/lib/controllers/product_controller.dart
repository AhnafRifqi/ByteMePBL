import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductController extends ChangeNotifier {
  final ProductService _productService = ProductService();

  bool _isLoading = false;
  String? _error;
  List<ProductModel> _allProducts = [];
  ProductModel? _selectedProduct;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ProductModel> get allProducts => _allProducts;
  ProductModel? get selectedProduct => _selectedProduct;

  Future<void> fetchAllProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allProducts = await _productService.getProducts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductById(String produkId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedProduct = await _productService.getProductById(produkId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(
    String nama,
    double harga,
    String deskripsi,
    String? filePath,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _productService.addProduct(nama, harga, deskripsi, filePath);
      await fetchAllProducts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProduct(
    String produkId,
    String nama,
    double harga,
    String deskripsi,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement update product service
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteProduct(String produkId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement delete product service
      await fetchAllProducts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
