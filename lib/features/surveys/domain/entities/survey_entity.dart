class SurveyEntity {
  final int id;
  final String surveyCode;
  final String projectName;
  final String surveyorName;
  final String surveyDate;
  final String landCondition; // 'Datar', 'Bergelombang', 'Curam'
  final String status; // 'pending', 'review', 'approved', 'rejected'
  final String notes;

  const SurveyEntity({
    required this.id,
    required this.surveyCode,
    required this.projectName,
    required this.surveyorName,
    required this.surveyDate,
    required this.landCondition,
    required this.status,
    required this.notes,
  });
}
