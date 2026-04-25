import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';
import 'product_controller.dart';
import 'order_controller.dart';
import 'notification_controller.dart';

/// Main list of all providers for the application
List<ChangeNotifierProvider> mainProviders = [
  ChangeNotifierProvider(create: (_) => AuthController()),
  ChangeNotifierProvider(create: (_) => CartController()),
  ChangeNotifierProvider(create: (_) => ProductController()),
  ChangeNotifierProvider(create: (_) => OrderController()),
  ChangeNotifierProvider(create: (_) => NotificationController()),
];