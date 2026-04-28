import 'package:flutter/material.dart';

// ============================================================
// APP THEME CONSTANTS - ByteMe Digital Marketplace
// Path: pbl/lib/utils/app_theme.dart
// Gunakan konstanta ini di semua screen untuk konsistensi
// ============================================================

class AppColors {
  AppColors._();

  // ── Primary palette ──
  static const Color primary = Color(0xFF6B7FD7);
  static const Color primaryDark = Color(0xFF3D4270);
  static const Color primaryLight = Color(0xFF8B90C1);
  static const Color primaryBg = Color(0xFFF0F2F8);

  // ── Accent ──
  static const Color accent = Color(0xFF5A72C6);

  // ── Semantic ──
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFFF4D67);
  static const Color info = Color(0xFF2196F3);

  // ── Neutral ──
  static const Color textPrimary = Color(0xFF1A1D2E);
  static const Color textSecondary = Color(0xFF9098B1);
  static const Color textHint = Color(0xFFB0B8CC);
  static const Color divider = Color(0xFFE8ECF4);
  static const Color cardBg = Color(0xFFF8F9FC);

  // ── Surface ──
  static const Color white = Colors.white;
  static const Color surfaceGrey = Color(0xFFE8E8F0);

  // ── Star ──
  static const Color star = Color(0xFFFFB800);
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle price = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle priceLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle badge = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
}

class AppDecorations {
  AppDecorations._();

  // ── Card ──
  static BoxDecoration card = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );

  static BoxDecoration cardSmall = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // ── Input ──
  static InputDecoration inputField({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
          color: AppColors.textHint, fontSize: 14),
      prefixIcon:
          Icon(icon, color: AppColors.textSecondary, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.divider, width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.5)),
      errorStyle:
          const TextStyle(fontSize: 11, color: AppColors.error),
    );
  }

  // ── Button ──
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    textStyle: AppTextStyles.buttonLabel,
    padding: const EdgeInsets.symmetric(vertical: 14),
  );

  static ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    side: const BorderSide(color: AppColors.primary, width: 1.5),
    foregroundColor: AppColors.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    padding: const EdgeInsets.symmetric(vertical: 14),
  );

  static ButtonStyle dangerButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.error,
    foregroundColor: AppColors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  // ── Badge ──
  static BoxDecoration badge(Color color) => BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      );

  // ── Status chip ──
  static Map<String, dynamic> statusChip(String status) {
    switch (status) {
      case 'menunggu':
        return {
          'color': AppColors.warning,
          'label': 'Menunggu',
          'icon': Icons.schedule_rounded,
        };
      case 'diproses':
        return {
          'color': AppColors.info,
          'label': 'Diproses',
          'icon': Icons.autorenew_rounded,
        };
      case 'dikirim':
        return {
          'color': const Color(0xFF9C27B0),
          'label': 'Dikirim',
          'icon': Icons.local_shipping_outlined,
        };
      case 'selesai':
        return {
          'color': AppColors.success,
          'label': 'Selesai',
          'icon': Icons.check_circle_outline_rounded,
        };
      case 'dibatalkan':
        return {
          'color': AppColors.error,
          'label': 'Dibatalkan',
          'icon': Icons.cancel_outlined,
        };
      case 'aktif':
        return {
          'color': AppColors.success,
          'label': 'Aktif',
          'icon': Icons.circle,
        };
      default:
        return {
          'color': AppColors.textSecondary,
          'label': status,
          'icon': Icons.info_outline_rounded,
        };
    }
  }
}

// ── Reusable Widgets ──

/// Tombol back yang konsisten di semua halaman
class AppBackButton extends StatelessWidget {
  final Color? bgColor;
  const AppBackButton({super.key, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor ?? const Color(0xFFF0F2F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1A1D2E), size: 18),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

/// Skeleton loading box
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECF4),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Empty state generik
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center),
            if (buttonLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: AppDecorations.primaryButton,
                  child: Text(buttonLabel!,
                      style: AppTextStyles.buttonLabel),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Star rating widget
class StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const StarRating({super.key, required this.rating, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(Icons.star_rounded,
              color: AppColors.star, size: size);
        } else if (i < rating) {
          return Icon(Icons.star_half_rounded,
              color: AppColors.star, size: size);
        } else {
          return Icon(Icons.star_outline_rounded,
              color: AppColors.divider, size: size);
        }
      }),
    );
  }
}