import 'package:flutter/material.dart';

class CompanyProfileCard extends StatefulWidget {
  final Function(String name, String address, String phone, String email)? onChanged;

  const CompanyProfileCard({super.key, this.onChanged});

  @override
  State<CompanyProfileCard> createState() => _CompanyProfileCardState();
}

class _CompanyProfileCardState extends State<CompanyProfileCard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'CV Arthamas Graha');
    _emailController = TextEditingController(text: 'info@arthamasgraha.com');
    _phoneController = TextEditingController(text: '021-5551234');
    _addressController = TextEditingController(
      text: 'Jl. Jenderal Sudirman No. 12, Jakarta Selatan',
    );

    _nameController.addListener(_notifyChanged);
    _emailController.addListener(_notifyChanged);
    _phoneController.addListener(_notifyChanged);
    _addressController.addListener(_notifyChanged);
  }

  void _notifyChanged() {
    widget.onChanged?.call(
      _nameController.text,
      _addressController.text,
      _phoneController.text,
      _emailController.text,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Pengaturan sistem dan profil perusahaan berhasil disimpan.'),
            ],
          ),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.bookmark_outline_rounded, color: Color(0xFF0F172A), size: 20),
                SizedBox(width: 12),
                Text(
                  'Profil & Identitas Perusahaan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildLabel('Nama Resmi Perusahaan *'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameController,
              style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
              decoration: _inputDecoration('Contoh: CV Arthamas Graha'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama resmi perusahaan wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            _buildLabel('Alamat Email Perusahaan *'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
              decoration: _inputDecoration('Contoh: info@arthamasgraha.com'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email perusahaan wajib diisi';
                if (!v.contains('@')) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildLabel('Nomor Telepon Kantor *'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
              decoration: _inputDecoration('Contoh: 021-5551234'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nomor telepon kantor wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            _buildLabel('Alamat Kantor Operasional *'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
              decoration: _inputDecoration('Masukkan alamat lengkap operasional perusahaan...'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Alamat kantor operasional wajib diisi' : null,
            ),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _handleSave,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.save_rounded, size: 18),
                  label: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF94A3B8),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF334155),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1.5),
      ),
    );
  }
}

