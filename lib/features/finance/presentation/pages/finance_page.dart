import 'package:flutter/material.dart';
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
  String _selectedTab = 'Semua';

  List<FinanceTransactionEntity> get _filteredTransactions {
    if (_selectedTab == 'Semua') return _transactions;
    if (_selectedTab == 'Pemasukan') return _transactions.where((t) => t.type == 'income').toList();
    return _transactions.where((t) => t.type == 'expense').toList();
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

  @override
  Widget build(BuildContext context) {
    const totalBudget = 132000000000.0;
    const totalSpent = 48000000000.0;
    const remainingBudget = 84000000000.0;
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TOTAL ALOKASI ANGGARAN (RAB)', style: TextStyle(color: Color(0xFF93C5FD), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(_formatRp(totalBudget), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('REALISASI BIAYA', style: TextStyle(color: Color(0xFF93C5FD), fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(_formatRp(totalSpent), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('SISA ANGGARAN', style: TextStyle(color: Color(0xFF93C5FD), fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(_formatRp(remainingBudget), style: const TextStyle(color: Color(0xFF6EE7B7), fontSize: 15, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Filter Tabs
              Row(
                children: ['Semua', 'Pengeluaran', 'Pemasukan'].map((tab) {
                  final isSel = _selectedTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tab),
                      labelStyle: TextStyle(
                        fontSize: 12,
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

              const Text(
                'Mutasi Transaksi Keuangan Proyek',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),

              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final t = list[index];
                  final isIncome = t.type == 'income';

                  return Container(
                    padding: const EdgeInsets.all(16),
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
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                              const SizedBox(height: 2),
                              Text(t.description, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              const SizedBox(height: 2),
                              Text('${t.projectName} · ${t.date}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${isIncome ? '+' : '-'}${_formatRp(t.amount)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isIncome ? const Color(0xFF059669) : const Color(0xFF0F172A),
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
