import 'package:flutter/material.dart';
import '../../../../core/widgets/summary_widgets.dart';
import '../../data/models/finance_transaction_model.dart';
import '../../domain/entities/finance_transaction_entity.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  static const String routeName = '/finance';

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final List<FinanceTransactionEntity> _transactions = List.from(FinanceTransactionModel.mockTransactions);
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FinanceTransactionEntity> get _filteredTransactions {
    final q = _searchController.text.trim().toLowerCase();
    return _transactions.where((t) {
      final matchesTab = _selectedTab == 'Semua' ||
          (_selectedTab == 'Pemasukan' && t.type == 'income') ||
          (_selectedTab == 'Pengeluaran' && t.type == 'expense');
      final matchesSearch = q.isEmpty ||
          t.description.toLowerCase().contains(q) ||
          t.category.toLowerCase().contains(q) ||
          t.projectName.toLowerCase().contains(q);
      return matchesTab && matchesSearch;
    }).toList();
  }

  String _formatRp(double val) {
    if (val >= 1000000000) {
      return 'Rp ${(val / 1000000000).toStringAsFixed(1)} M';
    }
    if (val >= 1000000) {
      return 'Rp ${(val / 1000000).toStringAsFixed(0)} Jt';
    }
    return 'Rp ${val.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _showAddTransactionModal() {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    final projectController = TextEditingController(text: 'Pembangunan Gedung Kantor PT Maju Jaya');
    String type = 'expense';
    String category = 'Material';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Catat Transaksi Keuangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Jenis Transaksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setModalState(() => type = 'expense'),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: type == 'expense' ? const Color(0xFFFFF1F2) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: type == 'expense' ? const Color(0xFFE11D48) : const Color(0xFFE2E8F0), width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text('Pengeluaran (Biaya)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: type == 'expense' ? const Color(0xFFE11D48) : const Color(0xFF64748B))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () => setModalState(() => type = 'income'),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: type == 'income' ? const Color(0xFFECFDF5) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: type == 'income' ? const Color(0xFF059669) : const Color(0xFFE2E8F0), width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text('Pemasukan (Termin)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: type == 'income' ? const Color(0xFF059669) : const Color(0xFF64748B))),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Kategori Transaksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: ['Material', 'Logistik', 'Upah', 'Operasional', 'Peralatan', 'Termin Pembayaran', 'Administrasi'].map((c) {
                    return DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => category = val);
                  },
                ),
                const SizedBox(height: 12),
                const Text('Nominal Jumlah (Rp)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                const SizedBox(height: 6),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Contoh: 15000000',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Uraian Keterangan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                const SizedBox(height: 6),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    hintText: 'Uraikan rincian pengeluaran atau pemasukan...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final amount = double.tryParse(amountController.text.trim()) ?? 0;
                      if (amount <= 0 || descController.text.trim().isEmpty) return;

                      setState(() {
                        _transactions.insert(
                          0,
                          FinanceTransactionEntity(
                            id: DateTime.now().millisecondsSinceEpoch,
                            type: type,
                            category: category,
                            description: descController.text.trim(),
                            amount: amount,
                            projectName: projectController.text.trim(),
                            date: 'Hari ini',
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaksi keuangan proyek berhasil dicatat!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('SIMPAN TRANSAKSI', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const totalBudget = 132000000000.0;
    const totalSpent = 48000000000.0;
    const remainingBudget = totalBudget - totalSpent;
    const pctSpent = (totalSpent / totalBudget) * 100;
    const netCashflow = 14800000000.0;
    final list = _filteredTransactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Keuangan Proyek',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync_outlined, color: Color(0xFF1D4ED8)),
            tooltip: 'Sinkronisasi Spreadsheet',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sinkronisasi mutasi kas Google Spreadsheet berhasil.'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Color(0xFF059669),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF1D4ED8)),
            tooltip: 'Catat Transaksi',
            onPressed: _showAddTransactionModal,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Executive Financial Overview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1D4ED8).withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL ALOKASI ANGGARAN (RAB)',
                          style: TextStyle(color: Color(0xFF93C5FD), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Status: Terkendali', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6EE7B7))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(_formatRp(totalBudget), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('REALISASI BIAYA', style: TextStyle(color: Color(0xFF93C5FD), fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(_formatRp(totalSpent), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                              Text('${pctSpent.toStringAsFixed(1)}% terpakai', style: const TextStyle(color: Color(0xFFBFDBFE), fontSize: 10)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('SISA ANGGARAN', style: TextStyle(color: Color(0xFF93C5FD), fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(_formatRp(remainingBudget), style: const TextStyle(color: Color(0xFF6EE7B7), fontSize: 14, fontWeight: FontWeight.bold)),
                              const Text('Surplus terkendali', style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pctSpent / 100,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6EE7B7)),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4 Stat Metric Cards (Persis Web v3)
              Row(
                children: [
                  Expanded(
                    child: AppMetricCard(
                      title: 'Total RAB',
                      value: _formatRp(totalBudget),
                      accentColor: const Color(0xFF0F172A),
                      titleFontSize: 9,
                      valueFontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: AppMetricCard(
                      title: 'Realisasi',
                      value: _formatRp(totalSpent),
                      accentColor: const Color(0xFF1D4ED8),
                      titleFontSize: 9,
                      valueFontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: AppMetricCard(
                      title: 'Arus Kas',
                      value: '+${_formatRp(netCashflow)}',
                      accentColor: const Color(0xFF059669),
                      titleFontSize: 9,
                      valueFontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: AppMetricCard(
                      title: 'Sisa Dana',
                      value: _formatRp(remainingBudget),
                      accentColor: const Color(0xFF059669),
                      titleFontSize: 9,
                      valueFontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              AppSearchBar(
                hintText: 'Cari transaksi, kategori, atau nama proyek...',
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),

              // Filter Tabs (Semua, Pengeluaran, Pemasukan)
              Row(
                children: ['Semua', 'Pengeluaran', 'Pemasukan'].map((tab) {
                  final isSel = _selectedTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tab),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSel ? Colors.white : const Color(0xFF475569),
                      ),
                      selected: isSel,
                      selectedColor: const Color(0xFF1D4ED8),
                      backgroundColor: Colors.white,
                      onSelected: (_) => setState(() => _selectedTab = tab),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Title Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mutasi Transaksi Keuangan Proyek',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  Text('${list.length} Transaksi', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
              const SizedBox(height: 10),

              // Transaction List
              if (list.isEmpty)
                const AppEmptyStateCard(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Tidak Ada Transaksi Keuangan',
                  message: 'Tidak ditemukan mutasi transaksi kas yang cocok dengan filter pencarian.',
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final t = list[index];
                    final isIncome = t.type == 'income';

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isIncome ? const Color(0xFFECFDF5) : const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                              color: isIncome ? const Color(0xFF059669) : const Color(0xFFE11D48),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppBadge(
                                      text: t.category,
                                      textColor: isIncome ? const Color(0xFF059669) : const Color(0xFF475569),
                                      backgroundColor: isIncome ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
                                      fontSize: 10,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t.description,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${t.projectName} • ${t.date}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${isIncome ? '+' : '-'}${_formatRp(t.amount)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isIncome ? const Color(0xFF059669) : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
