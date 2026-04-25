import 'package:flutter/foundation.dart';
import '../models/pesanan_model.dart';
import '../models/detail_pesanan_model.dart';
import '../services/pesanan_service.dart';

class OrderController extends ChangeNotifier {
  final PesananService _pesananService = PesananService();

  bool _isLoading = false;
  String? _error;
  List<PesananModel> _myOrders = [];
  PesananModel? _selectedOrder;
  List<DetailPesananModel> _orderDetails = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<PesananModel> get myOrders => _myOrders;
  PesananModel? get selectedOrder => _selectedOrder;
  List<DetailPesananModel> get orderDetails => _orderDetails;

  Future<void> fetchMyOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myOrders = await _pesananService.getMyOrders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrderById(String pesananId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedOrder = await _pesananService.getOrderById(pesananId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrderDetails(String pesananId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orderDetails = await _pesananService.getOrderDetails(pesananId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createOrder(
    List<Map<String, dynamic>> items,
    double totalHarga,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String? pesananId = await _pesananService.createOrder(items, totalHarga);
      await fetchMyOrders();
      _isLoading = false;
      notifyListeners();
      return pesananId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> cancelOrder(String pesananId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _pesananService.cancelOrder(pesananId);
      await fetchMyOrders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String pesananId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _pesananService.updateOrderStatus(pesananId, status);
      await fetchMyOrders();
      await fetchOrderById(pesananId);
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
