class DashboardStats {
  final int totalLinks;
  final int pendingLinks;
  final int paidLinks;
  final int expiredLinks;
  final double totalAmountPending;
  final double totalAmountCollected;

  DashboardStats({
    required this.totalLinks,
    required this.pendingLinks,
    required this.paidLinks,
    required this.expiredLinks,
    required this.totalAmountPending,
    required this.totalAmountCollected,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalLinks: json['totalLinks'] ?? 0,
      pendingLinks: json['pendingLinks'] ?? 0,
      paidLinks: json['paidLinks'] ?? 0,
      expiredLinks: json['expiredLinks'] ?? 0,
      totalAmountPending: (json['totalAmountPending'] ?? 0).toDouble(),
      totalAmountCollected: (json['totalAmountCollected'] ?? 0).toDouble(),
    );
  }
}