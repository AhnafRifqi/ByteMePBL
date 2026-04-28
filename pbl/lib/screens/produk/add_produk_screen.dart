import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/product_service.dart';

// ============================================================
// ADD PRODUK SCREEN - Polished UI
// Menggantikan: pbl/lib/screens/produk/add_produk_screen.dart
// ============================================================

class AddProdukScreen extends StatefulWidget {
  const AddProdukScreen({super.key});

  @override
  State<AddProdukScreen> createState() => _AddProdukScreenState();
}

class _AddProdukScreenState extends State<AddProdukScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _hargaCtrl = TextEditingController();
  final _deskripsiCtrl = TextEditingController();
  bool _isLoading = false;
  String? _selectedFile;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _namaCtrl.dispose();
    _hargaCtrl.dispose();
    _deskripsiCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ProductService().addProduct(
        _namaCtrl.text.trim(),
        double.parse(_hargaCtrl.text.replaceAll('.', '')),
        _deskripsiCtrl.text.trim(),
        _selectedFile ?? 'mock_path/file.zip',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Produk berhasil diterbitkan!'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal: $e'),
          backgroundColor: const Color(0xFFFF4D67),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFFF0F2F8),
              borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF1A1D2E), size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text('Jual Produk Digital',
            style: TextStyle(
                color: Color(0xFF1A1D2E),
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload area
                GestureDetector(
                  onTap: () {
                    setState(() => _selectedFile = 'mock_path/produk.zip');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'File picker akan tersedia setelah integrasi backend'),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedFile != null
                            ? const Color(0xFF6B7FD7)
                            : const Color(0xFFE8ECF4),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: _selectedFile != null
                                ? const Color(0xFF6B7FD7).withOpacity(0.12)
                                : const Color(0xFFF0F2F8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _selectedFile != null
                                ? Icons.check_circle_outline_rounded
                                : Icons.upload_file_rounded,
                            color: _selectedFile != null
                                ? const Color(0xFF6B7FD7)
                                : const Color(0xFF9098B1),
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedFile != null
                              ? 'File terpilih: ${_selectedFile!.split('/').last}'
                              : 'Upload File Produk',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedFile != null
                                ? const Color(0xFF6B7FD7)
                                : const Color(0xFF1A1D2E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedFile != null
                              ? 'Ketuk untuk ganti file'
                              : 'ZIP, PDF, atau format lainnya',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF9098B1)),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Form fields
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Nama Produk'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _namaCtrl,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF1A1D2E)),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama produk tidak boleh kosong'
                            : null,
                        decoration: _inputDecoration(
                            'Masukkan nama produk',
                            Icons.inventory_2_outlined),
                      ),
                      const SizedBox(height: 16),
                      _label('Harga (Rp)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _hargaCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF1A1D2E)),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Harga tidak boleh kosong';
                          }
                          if (double.tryParse(v) == null) {
                            return 'Harga tidak valid';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                            'Contoh: 50000', Icons.payments_outlined,
                            prefix: const Text('Rp ',
                                style: TextStyle(
                                    color: Color(0xFF1A1D2E),
                                    fontWeight: FontWeight.w600))),
                      ),
                      const SizedBox(height: 16),
                      _label('Deskripsi'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _deskripsiCtrl,
                        maxLines: 4,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF1A1D2E)),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Deskripsi tidak boleh kosong'
                            : null,
                        decoration: InputDecoration(
                          hintText: 'Deskripsikan produk kamu...',
                          hintStyle: const TextStyle(
                              color: Color(0xFFB0B8CC), fontSize: 14),
                          filled: true,
                          fillColor: const Color(0xFFF0F2F8),
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE8ECF4), width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF6B7FD7), width: 1.5)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFFFF4D67), width: 1.5)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B7FD7),
                      disabledBackgroundColor:
                          const Color(0xFF6B7FD7).withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5))
                        : const Text('Terbitkan Produk',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1D2E)));

  InputDecoration _inputDecoration(String hint, IconData icon,
      {Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(color: Color(0xFFB0B8CC), fontSize: 14),
      prefixIcon:
          Icon(icon, color: const Color(0xFF9098B1), size: 20),
      prefix: prefix,
      filled: true,
      fillColor: const Color(0xFFF0F2F8),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFE8ECF4), width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFF6B7FD7), width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFFFF4D67), width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFFFF4D67), width: 1.5)),
      errorStyle:
          const TextStyle(fontSize: 11, color: Color(0xFFFF4D67)),
    );
  }
}