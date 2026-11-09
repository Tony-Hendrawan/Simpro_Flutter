import '../../domain/entities/finance_transaction_entity.dart';

class FinanceTransactionModel extends FinanceTransactionEntity {
  const FinanceTransactionModel({
    required super.id,
    required super.projectName,
    required super.category,
    required super.description,
    required super.amount,
    required super.date,
    required super.type,
  });

  static List<FinanceTransactionModel> get mockTransactions => const [
    FinanceTransactionModel(
      id: 1,
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
      category: 'Subkontraktor',
      description: 'Termin I Pekerjaan Struktur Beton lantai 1 & 2',
      amount: 2500000000,
      date: '15 Mar 2026',
      type: 'expense',
    ),
    FinanceTransactionModel(
      id: 2,
      projectName: 'Pembangunan Jembatan Sungai Ciliwung',
      category: 'Alat Berat',
      description: 'Sewa Mobile Crane 50 Ton & Bore Pile Machine',
      amount: 850000000,
      date: '10 Mar 2026',
      type: 'expense',
    ),
    FinanceTransactionModel(
      id: 3,
      projectName: 'Renovasi Hotel Bintang Lima Nusantara',
      category: 'Material',
      description: 'Pembelian Keramik Roman dan Granit Lobi',
      amount: 350000000,
      date: '25 Feb 2026',
      type: 'expense',
    ),
    FinanceTransactionModel(
      id: 4,
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
      category: 'Termin Kontrak',
      description: 'Penerimaan Uang Muka Termin 1 (20%) dari Klien',
      amount: 3000000000,
      date: '20 Jan 2026',
      type: 'income',
    ),
    FinanceTransactionModel(
      id: 5,
      projectName: 'Renovasi Hotel Bintang Lima Nusantara',
      category: 'Tenaga Kerja',
      description: 'Pembayaran Upah Mandor & Tukang Finishing',
      amount: 180000000,
      date: '05 Mar 2026',
      type: 'expense',
    ),
    FinanceTransactionModel(
      id: 6,
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
      category: 'Material',
      description: 'Pembelian Semen Gresik 1000 sak',
      amount: 68000000,
      date: '20 Jan 2026',
      type: 'expense',
    ),
  ];
}
