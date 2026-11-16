enum RelatedOrderItemType { cleaningContract, project }

class RelatedOrderItem {
  const RelatedOrderItem({
    required this.type,
    required this.referenceNumber,
    required this.title,
    required this.status,
    required this.subtitle,
    required this.date,
    required this.data,
  });

  final RelatedOrderItemType type;
  final String referenceNumber;
  final String title;
  final String status;
  final String subtitle;
  final DateTime? date;
  final Map<String, dynamic> data;

  bool get isCompleted =>
      data['status']?.toString().trim().toLowerCase() == 'completed';

  factory RelatedOrderItem.fromJson(
    Map<String, dynamic> json, {
    required RelatedOrderItemType type,
  }) {
    final container = json['container'];
    final product = json['product'];
    final number = type == RelatedOrderItemType.cleaningContract
        ? json['contract_number']
        : json['reference_number'];
    final title = type == RelatedOrderItemType.cleaningContract
        ? (container is Map ? container['name'] : null)
        : json['name'];
    final statusLabel = json['status_label'];
    final completed = json['completed_pickups'] ?? json['completed_discharges'];
    final total = json['total_pickups'] ?? json['total_discharges'];
    final subtitle = type == RelatedOrderItemType.cleaningContract
        ? json['duration']
        : completed != null && total != null
            ? '$completed / $total'
            : json['frequency_label'];
    final dateValue = json['start_date'] ?? json['created_at'];

    return RelatedOrderItem(
      type: type,
      referenceNumber: number?.toString() ?? json['id']?.toString() ?? '---',
      title: (title ?? (product is Map ? product['title'] : null) ?? '---')
          .toString(),
      status: (statusLabel ?? json['status'] ?? '').toString(),
      subtitle: (subtitle ?? '').toString(),
      date: dateValue is String ? DateTime.tryParse(dateValue) : null,
      data: Map<String, dynamic>.from(json),
    );
  }
}
