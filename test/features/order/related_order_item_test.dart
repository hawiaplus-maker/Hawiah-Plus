import 'package:flutter_test/flutter_test.dart';
import 'package:hawiah_client/features/order/presentation/model/related_order_item.dart';

void main() {
  group('RelatedOrderItem.fromJson', () {
    test('parses project list fields', () {
      final item = RelatedOrderItem.fromJson(
        {
          'id': 12,
          'reference_number': 'PRJ-12',
          'name': 'Project name',
          'status': 'active',
          'status_label': 'مشروع نشط',
          'completed_pickups': 4,
          'total_pickups': 10,
          'start_date': '2026-10-20',
          'pickups': [
            {'id': 1},
          ],
        },
        type: RelatedOrderItemType.project,
      );

      expect(item.referenceNumber, 'PRJ-12');
      expect(item.title, 'Project name');
      expect(item.status, 'مشروع نشط');
      expect(item.isCompleted, isFalse);
      expect(item.subtitle, '4 / 10');
      expect(item.date, DateTime(2026, 10, 20));
      expect(item.data['pickups'], [
        {'id': 1},
      ]);
    });

    test('parses cleaning contract fields', () {
      final item = RelatedOrderItem.fromJson(
        {
          'id': 6,
          'contract_number': 'CLN-2026-00006',
          'status': 'completed',
          'duration': 'سنة واحدة',
          'start_date': '2026-10-21T21:00:00.000000Z',
          'container': {'name': 'حاوية نظافة 20 ياردة'},
        },
        type: RelatedOrderItemType.cleaningContract,
      );

      expect(item.referenceNumber, 'CLN-2026-00006');
      expect(item.title, 'حاوية نظافة 20 ياردة');
      expect(item.status, 'completed');
      expect(item.isCompleted, isTrue);
      expect(item.subtitle, 'سنة واحدة');
      expect(item.date, DateTime.parse('2026-10-21T21:00:00.000000Z'));
      expect(item.data['container'], {'name': 'حاوية نظافة 20 ياردة'});
    });
  });
}
