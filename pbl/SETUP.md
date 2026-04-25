# ByteMePBL - Marketplace Digital Products

Aplikasi Flutter untuk marketplace produk digital dengan fitur lengkap: autentikasi, keranjang belanja, pesanan, pembayaran, review, notifikasi, dan admin panel.

## 🏗️ Struktur Project

```
lib/
├── main.dart                          # Entry point app
├── models/                            # Data models (9 model)
│   ├── product_model.dart
│   ├── profile_model.dart
│   ├── keranjang_model.dart
│   ├── detail_keranjang_model.dart
│   ├── pesanan_model.dart
│   ├── detail_pesanan_model.dart
│   ├── pembayaran_model.dart
│   ├── review_model.dart
│   ├── peninjauan_model.dart
│   ├── sanksi_akun_model.dart
│   └── notifikasi_model.dart
├── services/                          # Business logic (7 service)
│   ├── auth_service.dart              # Autentikasi
│   ├── product_service.dart           # Manajemen produk
│   ├── storage_service.dart           # File upload/download
│   ├── keranjang_service.dart         # Manajemen keranjang
│   ├── pesanan_service.dart           # Manajemen pesanan
│   ├── pembayaran_service.dart        # Proses pembayaran
│   ├── review_service.dart            # Review produk
│   ├── peninjauan_service.dart        # Admin review
│   ├── notifikasi_service.dart        # Notifikasi real-time
│   └── notification_service.dart      # Notifikasi push
├── providers/                         # Riverpod state management (5 provider)
│   ├── auth_provider.dart
│   ├── product_provider.dart
│   ├── cart_provider.dart
│   ├── order_provider.dart
│   └── notification_provider.dart
├── screens/                           # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── produk/
│   │   ├── list_produk_screen.dart
│   │   └── add_produk_screen.dart
│   ├── cart/
│   │   └── cart_screen.dart
│   ├── checkout/
│   │   └── checkout_screen.dart
│   ├── order/
│   │   ├── order_history_screen.dart
│   │   └── order_detail_screen.dart
│   ├── review/
│   │   └── review_product_screen.dart
│   ├── notifikasi/
│   │   └── notifikasi_screen.dart
│   └── admin/
│       └── peninjauan_screen.dart
└── widgets/
    ├── admin_guard.dart
    └── notifikasi_listener.dart
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.3.0      # Backend & Database
  flutter_riverpod: ^2.4.0      # State Management
  uuid: ^4.0.0                  # ID generation
  intl: ^0.19.0                 # Date formatting
  dio: ^5.3.0                   # HTTP client
  shared_preferences: ^2.2.0    # Local storage
  path_provider: ^2.1.0         # File paths
  image_picker: ^1.0.0          # Image selection
  image: ^4.1.0                 # Image processing
```

## 🚀 Setup Instructions

### 1. Setup Supabase Database

Jalankan SQL script di Supabase SQL Editor:
- File: `supabase_schema.sql` (berisi schema lengkap)
- Includes: Tables, RLS policies, triggers, storage buckets

### 2. Konfigurasi Credentials

Update `lib/main.dart`:
```dart
await Supabase.initialize(
  url: 'https://YOUR_PROJECT.supabase.co',
  anonKey: 'YOUR_ANON_KEY',
);
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run App

```bash
flutter run
```

## 🔐 Database Schema Overview

### Tables (11 tabel utama)
1. **profiles** - User profiles (synced dengan auth.users)
2. **produk** - Product catalog
3. **keranjang** - Shopping cart
4. **detail_keranjang** - Cart items
5. **pesanan** - Orders
6. **detail_pesanan** - Order items
7. **pembayaran** - Payments
8. **review** - Product reviews
9. **peninjauan** - Admin product review
10. **sanksi_akun** - Account sanctions
11. **notifikasi** - Notifications

### Key Features
- ✅ Row Level Security (RLS) - User data privacy
- ✅ Triggers - Auto notifications, cart sync
- ✅ Storage Buckets - Digital products & images
- ✅ Realtime - Live notifications
- ✅ Indexes - Query optimization

## 🎯 Features

### User Features
- 📝 Register & Login
- 🔍 Browse products
- 🛒 Shopping cart
- 💳 Multiple payment methods
- 📦 Track orders
- ⭐ Leave reviews
- 🔔 Notifications
- 📁 Download digital products

### Seller Features
- ➕ Add/Edit products
- 📊 Product management
- 📥 Upload files (digital products)
- 🖼️ Upload images
- 📋 View product reviews
- 💰 Sales tracking

### Admin Features
- 👀 Review products
- ⚠️ Issue warnings/suspensions/bans
- 🚫 Manage account sanctions
- 📊 User management
- 🔍 View notifications

## 📡 API Endpoints (Services)

### AuthService
- `register()` - Register user
- `login()` - Login user
- `logout()` - Logout user
- `getMyRole()` - Get user role
- `getCurrentUserProfile()` - Get profile

### ProductService
- `getProducts()` - List all products
- `getProductById()` - Get product detail
- `addProduct()` - Create product (seller)
- `updateProduct()` - Update product
- `deleteProduct()` - Delete product

### KeranjangService
- `getMyCart()` - Get user cart
- `getCartItems()` - Get cart items
- `addToCart()` - Add item to cart
- `updateCartItem()` - Update quantity
- `removeFromCart()` - Remove item
- `clearCart()` - Clear all items

### PesananService
- `getMyOrders()` - Get user orders
- `getOrderById()` - Get order detail
- `getOrderDetails()` - Get order items
- `createOrder()` - Create order
- `cancelOrder()` - Cancel order
- `updateOrderStatus()` - Update status

### PembayaranService
- `getPaymentByOrderId()` - Get payment
- `createPayment()` - Create payment
- `updatePaymentStatus()` - Update status
- `getMyPayments()` - List payments

### ReviewService
- `getProductReviews()` - Get product reviews
- `getMyReview()` - Get my review
- `createReview()` - Create review
- `updateReview()` - Edit review
- `getAverageRating()` - Average rating

### StorageService
- `uploadProductFile()` - Upload digital product
- `uploadProductImage()` - Upload product image
- `getPublicImageUrl()` - Get image URL
- `downloadProductFile()` - Download product
- `deleteProductFile()` - Delete file

### NotifikasiService
- `getMyNotifications()` - List notifications
- `getUnreadCount()` - Unread count
- `markAsRead()` - Mark as read
- `markAllAsRead()` - Mark all as read
- `deleteNotification()` - Delete notification
- `subscribeToNotifications()` - Real-time updates

## 🔄 State Management (Riverpod)

### Providers
- `authNotifierProvider` - Auth state
- `productNotifierProvider` - Product state
- `cartNotifierProvider` - Cart state
- `orderNotifierProvider` - Order state
- `notificationNotifierProvider` - Notification state

## 🛡️ Security Features

- ✅ Row Level Security (RLS) policies
- ✅ Role-based access control
- ✅ Password hashing (Supabase Auth)
- ✅ JWT tokens
- ✅ File upload restrictions
- ✅ Admin guard middleware
- ✅ Account sanctions system

## 📱 Screen Routes

```
/login                    → Login screen
/register                 → Register screen
/home                     → Home screen
/produk-list              → Product list
/produk-add               → Add product (seller)
/cart                     → Shopping cart
/checkout                 → Checkout & payment
/order-history            → Order history
/order-detail/{id}        → Order detail
/review/{produkId}        → Leave review
/notifikasi               → Notifications
/admin-review             → Admin product review
```

## 🧪 Testing Checklist

- [ ] User registration & login
- [ ] Add product to cart
- [ ] Checkout process
- [ ] Payment processing
- [ ] Order tracking
- [ ] Review submission
- [ ] Notification updates
- [ ] Admin review process
- [ ] File upload/download
- [ ] Account sanctions

## 📝 Notes

- Replace `YOUR_PROJECT` dan `YOUR_ANON_KEY` di main.dart
- Pastikan Supabase buckets sudah created
- Enable Realtime di Supabase settings
- Setup RLS policies sesuai schema SQL
- Test dengan berbagai user roles (pembeli, penjual, admin)

## 🤝 Contributing

Untuk menambah fitur atau fix bug, buat pull request ke repository ini.

## 📄 License

MIT License - Bebas digunakan untuk keperluan komersial maupun non-komersial.
