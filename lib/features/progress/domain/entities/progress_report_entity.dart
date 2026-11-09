class ProgressReportEntity {
  final int id;
  final String projectName;
  final double currentProgress;
  final double addedProgress;
  final String reportDate;
  final String reporter;
  final String description;

  const ProgressReportEntity({
    required this.id,
    required this.projectName,
    required this.currentProgress,
    required this.addedProgress,
    required this.reportDate,
    required this.reporter,
    required this.description,
  });
}
