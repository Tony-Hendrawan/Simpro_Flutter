class ProjectEntity {
  final int id;
  final String code;
  final String name;
  final String location;
  final String clientName;
  final double contractValue;
  final double budget;
  final double spent;
  final double progress;
  final String status; // 'aktif', 'perencanaan', 'selesai', 'tertunda'
  final String manager;
  final int completedDocsCount;

  const ProjectEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.location,
    required this.clientName,
    required this.contractValue,
    required this.budget,
    required this.spent,
    required this.progress,
    required this.status,
    required this.manager,
    this.completedDocsCount = 4,
  });
}
