import 'dart:math' as math;
import 'package:flutter/material.dart';

class DashboardExpenseCard extends StatelessWidget {
  const DashboardExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Kategori Pengeluaran sama persis dengan tabel ProjectTransaction & seeder web
    final categories = [
      (
        name: 'Subkontraktor',
        amount: 2500000000.0,
        amountStr: 'Rp 2.500.000.000',
        color: const Color(0xFF1D4ED8),
      ),
      (
        name: 'Alat Berat',
        amount: 895000000.0,
        amountStr: 'Rp 895.000.000',
        color: const Color(0xFF2563EB),
      ),
      (
        name: 'Material',
        amount: 418000000.0,
        amountStr: 'Rp 418.000.000',
        color: const Color(0xFF0EA5E9),
      ),
      (
        name: 'Tenaga Kerja',
        amount: 300000000.0,
        amountStr: 'Rp 300.000.000',
        color: const Color(0xFF10B981),
      ),
      (
        name: 'Peralatan',
        amount: 35000000.0,
        amountStr: 'Rp 35.000.000',
        color: const Color(0xFFF59E0B),
      ),
    ];

    final totalExpenses = categories.fold<double>(0.0, (acc, item) => acc + item.amount);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Kategori Pengeluaran',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                'Detail',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Nilai pengeluaran berdasarkan kategori transaksi.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),

          // Doughnut Chart
          Center(
            child: SizedBox(
              width: 170,
              height: 170,
              child: CustomPaint(
                painter: _DoughnutChartPainter(
                  categories: categories,
                  total: totalExpenses,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Biaya',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Rp 4,14 M',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // List Rincian Kategori dengan progress bar
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final pct = (cat.amount / totalExpenses) * 100;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: cat.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                cat.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${cat.amountStr} (${pct.toStringAsFixed(1)}%)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: cat.amount / totalExpenses,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(cat.color),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Custom Painter untuk Doughnut Chart
class _DoughnutChartPainter extends CustomPainter {
  final List<({String name, double amount, String amountStr, Color color})> categories;
  final double total;

  _DoughnutChartPainter({required this.categories, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 22.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    double startAngle = -math.pi / 2;

    for (final cat in categories) {
      final sweepAngle = (cat.amount / total) * 2 * math.pi;

      final paint = Paint()
        ..color = cat.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle - 0.04, // Memberi sedikit gap pemisah antar segmen
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
