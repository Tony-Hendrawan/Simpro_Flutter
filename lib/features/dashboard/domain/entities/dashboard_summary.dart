import 'package:flutter/material.dart';

class DashboardSummary {
  final int totalProjects;
  final int activeProjects;
  final int completedProjects;
  final String totalRab;
  final String realisasiBiaya;
  final String sisaAnggaran;
  final double realisasiPercent;
  final String budgetStatus;
  final List<ProjectProgressItem> projectProgress;
  final List<ExpenseCategoryItem> expenseCategories;
  final List<QuickActionItem> quickActions;

  const DashboardSummary({
    required this.totalProjects,
    required this.activeProjects,
    required this.completedProjects,
    required this.totalRab,
    required this.realisasiBiaya,
    required this.sisaAnggaran,
    required this.realisasiPercent,
    required this.budgetStatus,
    required this.projectProgress,
    required this.expenseCategories,
    required this.quickActions,
  });
}

class ProjectProgressItem {
  final String projectName;
  final double progressFisik;
  final String rab;
  final String realisasi;
  final double realisasiPercent;

  const ProjectProgressItem({
    required this.projectName,
    required this.progressFisik,
    required this.rab,
    required this.realisasi,
    required this.realisasiPercent,
  });
}

class ExpenseCategoryItem {
  final String category;
  final double amount;
  final String amountFormatted;
  final Color color;

  const ExpenseCategoryItem({
    required this.category,
    required this.amount,
    required this.amountFormatted,
    required this.color,
  });
}

class QuickActionItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
