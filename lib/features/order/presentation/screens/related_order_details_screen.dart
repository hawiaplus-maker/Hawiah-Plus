import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/order/presentation/model/related_order_item.dart';

class RelatedOrderDetailsScreen extends StatelessWidget {
  const RelatedOrderDetailsScreen({super.key, required this.item});

  final RelatedOrderItem item;

  @override
  Widget build(BuildContext context) {
    final isProject = item.type == RelatedOrderItemType.project;
    final data = item.data;
    final client = data['client'];
    final city = data['city'];
    final provider = data['service_provider'];
    final container = data['container'];

    final customerFields = [
      ('customer_name', data['customer_name'] ?? _nested(client, 'name')),
      ('customer_phone', data['customer_phone'] ?? _nested(client, 'mobile')),
      ('customer_email', data['customer_email']),
      ('service_provider', _nested(provider, 'name')),
      ('city', _localized(context, _nested(city, 'title'))),
      ('district', data['district']),
      ('address', data['address'] ?? data['location_address']),
    ];

    final detailFields = isProject
        ? [
            ('frequency', data['frequency_label'] ?? data['frequency']),
            ('start_date', data['start_date']),
            ('end_date', data['end_date']),
          ]
        : [
            ('container', _nested(container, 'name')),
            ('duration', data['duration']),
            ('container_quantity', data['container_quantity']),
            ('discharges_per_week', data['discharges_per_week']),
            ('start_date', data['start_date']),
            ('end_date', data['end_date']),
            ('payment_method', data['payment_method']),
            // ('paid_status', data['paid_status']),
            ('delivery_status', data['delivery_status']),
          ];

    final priceFields = isProject
        ? [
            ('subtotal', data['subtotal']),
            ('vat_amount', data['vat_amount']),
            ('total_price', data['total_price']),
          ]
        : [
            ('container_price', data['container_price']),
            ('price_per_discharge', data['price_per_discharge']),
            ('subtotal', data['subtotal']),
            ('vat_amount', data['vat_amount']),
            ('total_amount', data['total_amount']),
          ];

    final pickups = data['pickups'];

    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Column(
          children: [
            Text(AppLocaleKey.orderDetails.tr(),
                style: AppTextStyle.text16_700),
            const SizedBox(height: 5),
            Text(item.referenceNumber, style: AppTextStyle.text14_400),
          ],
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
        children: [
          _OrderHeader(item: item),
          if (customerFields.any(_hasValue)) ...[
            const SizedBox(height: 14),
            _DetailsSection(
              title: AppLocaleKey.customerData.tr(),
              fields: customerFields,
            ),
          ],
          if (detailFields.any(_hasValue)) ...[
            const SizedBox(height: 14),
            _DetailsSection(
              title: AppLocaleKey.orderdata.tr(),
              fields: detailFields,
            ),
          ],
          if (priceFields.any(_hasValue)) ...[
            const SizedBox(height: 14),
            _DetailsSection(
              title: AppLocaleKey.priceDetails.tr(),
              fields: priceFields,
              emphasizeLast: true,
              appendCurrency: true,
            ),
          ],
          if (isProject) ...[
            const SizedBox(height: 14),
            _ProjectProgress(data: data),
          ],
          if (isProject && pickups is List && pickups.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(AppLocaleKey.pickups.tr(), style: AppTextStyle.text16_700),
            const SizedBox(height: 8),
            ...pickups.whereType<Map<String, dynamic>>().map(
                  (pickup) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _PickupCard(pickup: pickup),
                  ),
                ),
            SizedBox(height: 80),
          ],
        ],
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  const _OrderHeader({required this.item});

  final RelatedOrderItem item;

  @override
  Widget build(BuildContext context) {
    final data = item.data;
    final status = (data['status_label'] ?? data['status'] ?? '').toString();
    final provider = data['service_provider'];
    final providerName = _localized(context, _nested(provider, 'name'));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.mainAppColor, width: .3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(AppLocaleKey.orderdata.tr(), style: AppTextStyle.text16_700),
              const Spacer(),
              if (status.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _statusColor(data['status']?.toString() ?? '')
                        .withAlpha(50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyle.text14_500.copyWith(
                      color: _statusColor(data['status']?.toString() ?? ''),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.title, style: AppTextStyle.text16_700),
          const SizedBox(height: 6),
          Text(
            '${item.type == RelatedOrderItemType.project ? AppLocaleKey.projects.tr() : AppLocaleKey.contract.tr()} · ${AppLocaleKey.orderCode.tr()} ${item.referenceNumber}',
            style: AppTextStyle.text14_500.copyWith(color: AppColor.greyColor),
          ),
          if (providerName.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '${AppLocaleKey.serviceProviders.tr()}: $providerName',
              style:
                  AppTextStyle.text14_500.copyWith(color: AppColor.greyColor),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.title,
    required this.fields,
    this.emphasizeLast = false,
    this.appendCurrency = false,
  });

  final String title;
  final List<(String, dynamic)> fields;
  final bool emphasizeLast;
  final bool appendCurrency;

  @override
  Widget build(BuildContext context) {
    final visibleFields = fields.where(_hasValue).toList();
    if (visibleFields.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.grey100Color.withAlpha(50),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.mainAppColor, width: .3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyle.text16_700),
          const SizedBox(height: 12),
          for (var index = 0; index < visibleFields.length; index++) ...[
            if (index > 0) const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _fieldLabel(context, visibleFields[index].$1),
                    style: AppTextStyle.text14_400,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _fieldValue(
                      context,
                      visibleFields[index].$1,
                      visibleFields[index].$2,
                      appendCurrency: appendCurrency &&
                          _isMoneyField(visibleFields[index].$1),
                    ),
                    textAlign: TextAlign.end,
                    style: emphasizeLast && index == visibleFields.length - 1
                        ? AppTextStyle.text14_600
                            .copyWith(color: AppColor.mainAppColor)
                        : AppTextStyle.text14_400,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProjectProgress extends StatelessWidget {
  const _ProjectProgress({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final completed = _number(data['completed_pickups']);
    final total = _number(data['total_pickups']);
    final percentage = _number(data['progress_percentage']) ??
        (total != null && total > 0 && completed != null
            ? completed / total * 100
            : null);
    if (percentage == null && completed == null && total == null) {
      return const SizedBox.shrink();
    }

    final progress = (percentage ?? 0).clamp(0, 100) / 100;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.grey100Color.withAlpha(50),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.mainAppColor, width: .3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocaleKey.pickups.tr(), style: AppTextStyle.text16_700),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColor.mainAppColor.withAlpha(35),
              valueColor: AlwaysStoppedAnimation(AppColor.mainAppColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${completed?.toInt() ?? 0} / ${total?.toInt() ?? 0} · ${percentage?.toInt() ?? 0}%',
            style: AppTextStyle.text14_500,
          ),
        ],
      ),
    );
  }
}

class _PickupCard extends StatelessWidget {
  const _PickupCard({required this.pickup});

  final Map<String, dynamic> pickup;

  @override
  Widget build(BuildContext context) {
    final driver = pickup['driver'];
    final title = pickup['pickup_number']?.toString() ??
        pickup['reference_number']?.toString() ??
        pickup['id']?.toString() ??
        '';
    final status =
        (pickup['status_label'] ?? pickup['status'] ?? '').toString();
    final fields = [
      ('scheduled_date', pickup['scheduled_date']),
      ('scheduled_time', pickup['scheduled_time']),
      ('container', pickup['container_name']),
      ('driver', _nested(driver, 'name')),
      ('driver_notes', pickup['driver_notes']),
    ].where(_hasValue).toList();
    final images = [
      (AppLocaleKey.imageBefore.tr(), pickup['image_before']?.toString() ?? ''),
      (AppLocaleKey.imageAfter.tr(), pickup['image_after']?.toString() ?? ''),
    ].where((image) => image.$2.isNotEmpty).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.mainAppColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#$title',
                  style: AppTextStyle.text14_600,
                ),
              ),
              if (status.isNotEmpty)
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColor.mainAppColor.withAlpha(45),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      status,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.text14_400
                          .copyWith(color: AppColor.mainAppColor),
                    ),
                  ),
                ),
            ],
          ),
          for (final field in fields) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(_fieldLabel(context, field.$1))),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _fieldValue(context, field.$1, field.$2),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
          if (images.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final image in images)
                  SizedBox(
                    width: (MediaQuery.sizeOf(context).width - 56) / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(image.$1, style: AppTextStyle.text14_400),
                        const SizedBox(height: 6),
                        CustomNetworkImage(
                          imageUrl: image.$2,
                          height: 110,
                          width: double.infinity,
                          radius: 8,
                          hasZoom: true,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

bool _hasValue((String, dynamic) field) =>
    field.$2 != null && field.$2.toString().isNotEmpty;

dynamic _nested(dynamic object, String key) =>
    object is Map ? object[key] : null;

String _fieldLabel(BuildContext context, String key) {
  return switch (key) {
    'address' => AppLocaleKey.address.tr(),
    'city' => AppLocaleKey.city.tr(),
    'customer_name' => AppLocaleKey.name.tr(),
    'customer_phone' => AppLocaleKey.phoneNumber.tr(),
    'customer_email' => AppLocaleKey.email.tr(),
    'service_provider' => AppLocaleKey.serviceProviders.tr(),
    'start_date' || 'scheduled_date' => AppLocaleKey.startdate.tr(),
    'end_date' => AppLocaleKey.enddate.tr(),
    'payment_method' => AppLocaleKey.paymentMethod.tr(),
    'paid_status' || 'payment_status' => AppLocaleKey.paymentStatus.tr(),
    'delivery_status' => AppLocaleKey.deliveryStatus.tr(),
    'duration' => AppLocaleKey.duration.tr(),
    'frequency' => AppLocaleKey.frequency.tr(),
    'container_quantity' => AppLocaleKey.quantity.tr(),
    'discharges_per_week' => AppLocaleKey.dischargesPerWeek.tr(),
    'container_price' => AppLocaleKey.containerPrice.tr(),
    'price_per_discharge' => AppLocaleKey.pricePerDischarge.tr(),
    'subtotal' => AppLocaleKey.subtotal.tr(),
    'vat_amount' => AppLocaleKey.vatAmount.tr(),
    'total_amount' || 'total_price' => AppLocaleKey.totalPrice.tr(),
    'status' => AppLocaleKey.state.tr(),
    'progress_percentage' => AppLocaleKey.progress.tr(),
    'container' => AppLocaleKey.name.tr(),
    _ => key
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' '),
  };
}

bool _isMoneyField(String key) => const {
      'container_price',
      'price_per_discharge',
      'subtotal',
      'vat_amount',
      'total_amount',
      'total_price',
    }.contains(key);

String _fieldValue(
  BuildContext context,
  String key,
  dynamic value, {
  bool appendCurrency = false,
}) {
  if (value is Map) return _localized(context, value).toString();
  if (key.endsWith('_date') && value is String) {
    final date = DateTime.tryParse(value);
    if (date != null) return DateMethods.formatToFullData(date);
  }
  final text = value.toString();
  return appendCurrency ? '$text ${AppLocaleKey.sarr.tr()}' : text;
}

dynamic _localized(BuildContext context, dynamic value) {
  if (value is! Map) return value;
  return value[context.locale.languageCode] ?? value['en'] ?? value['ar'] ?? '';
}

double? _number(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

Color _statusColor(String status) {
  final normalized = status.toLowerCase();
  if (normalized.contains('reject') || normalized.contains('cancel')) {
    return AppColor.redColor;
  }
  if (normalized.contains('pending')) return AppColor.statusOrangeColor;
  if (normalized.contains('active') ||
      normalized.contains('approved') ||
      normalized.contains('completed')) {
    return AppColor.mainAppColor;
  }
  return AppColor.textGrayColor;
}
