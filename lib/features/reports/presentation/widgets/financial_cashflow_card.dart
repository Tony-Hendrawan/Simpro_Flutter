import 'dart:math' as math;
import 'package:flutter/material.dart';

class FinancialCashflowCard extends StatefulWidget {
  const FinancialCashflowCard({super.key});

  @override
  State<FinancialCashflowCard> createState() => _FinancialCashflowCardState();
}

class _FinancialCashflowCardState extends State<FinancialCashflowCard> {
  // 0: Anggaran Proyek, 1: Arus Kas 6 Bulan
  int _activeTab = 0;

  // Data Anggaran Proyek (RAB vs Realisasi) persis seperti di web
  static const List<({String name, double budget, double spent})> _projectBudgets = [
    (name: 'Gedung Kantor', budget: 12.0, spent: 5.4),
    (name: 'Hotel Nusantara', budget: 7.5, spent: 5.1),
    (name: 'Jembatan Ciliwung', budget: 22.0, spent: 7.0),
    (name: 'Green Valley', budget: 30.0, spent: 16.5),
    (name: 'Gudang Cikupa', budget: 10.0, spent: 0.5),
    (name: 'Masjid Al-Ikhlas', budget: 3.5, spent: 2.5),
  ];

  // Data Arus Kas 6 Bulan (Pemasukan vs Pengeluaran dalam Miliar Rp)
  static const List<({String month, double income, double expense})> _cashflows = [
    (month: 'Nov 25', income: 4.2, expense: 3.1),
    (month: 'Des 25', income: 6.5, expense: 5.8),
    (month: 'Jan 26', income: 3.8, expense: 2.9),
    (month: 'Feb 26', income: 7.2, expense: 4.6),
    (month: 'Mar 26', income: 5.0, expense: 4.1),
    (month: 'Apr 26', income: 8.5, expense: 6.2),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Visualisasi Finansial Proyek
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Visualisasi Finansial Proyek',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _activeTab == 0
                          ? 'Perbandingan alokasi RAB terhadap realisasi pengeluaran per proyek.'
                          : 'Tren pemasukan dan pengeluaran operasional 6 bulan berjalan.',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Switcher Tab Button (Anggaran Proyek / Arus Kas 6 Bulan)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _activeTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: _activeTab == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _activeTab == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Anggaran Proyek',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _activeTab == 0 ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _activeTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: _activeTab == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _activeTab == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Arus Kas 6 Bulan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _activeTab == 1 ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Chart Display
          SizedBox(
            height: 190,
            child: _activeTab == 0 ? _buildProjectBudgetChart() : _buildCashflowChart(),
          ),

          const SizedBox(height: 14),

          // Legend
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _activeTab == 0
                  ? [
                      _buildLegendItem(const Color(0xFF1D4ED8), 'Anggaran (RAB)'),
                      const SizedBox(width: 16),
                      _buildLegendItem(const Color(0xFF10B981), 'Realisasi Biaya'),
                    ]
                  : [
                      _buildLegendItem(const Color(0xFF10B981), 'Pemasukan'),
                      const SizedBox(width: 16),
                      _buildLegendItem(const Color(0xFFE11D48), 'Pengeluaran'),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // Grafik Batang: RAB vs Realisasi (dalam satuan Miliar)
  Widget _buildProjectBudgetChart() {
    const maxVal = 35.0; // Max Miliar untuk penskalaan
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _projectBudgets.map((item) {
        final budgetHeight = (item.budget / maxVal) * 140;
        final spentHeight = (item.spent / maxVal) * 140;
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 10,
                    height: math.max(budgetHeight, 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D4ED8),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Container(
                    width: 10,
                    height: math.max(spentHeight, 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.name.length > 7 ? '${item.name.substring(0, 6)}..' : item.name,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Grafik Batang: Arus Kas 6 Bulan (Pemasukan vs Pengeluaran)
  Widget _buildCashflowChart() {
    const maxVal = 10.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _cashflows.map((item) {
        final incHeight = (item.income / maxVal) * 140;
        final expHeight = (item.expense / maxVal) * 140;
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 10,
                    height: math.max(incHeight, 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Container(
                    width: 10,
                    height: math.max(expHeight, 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE11D48),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.month,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

