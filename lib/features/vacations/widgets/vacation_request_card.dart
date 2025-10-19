// lib/features/vacations/widgets/vacation_request_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/models/vacation_request_model.dart';

class VacationRequestCard extends StatelessWidget {
  final VacationRequestItem request;
  final VoidCallback onTap;

  const VacationRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  String _formatDate(String? dateString, String locale) {
    if (dateString == null || dateString.isEmpty) return '...';
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat.yMd(locale).format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    final empName = isArabic ? request.empName : (request.empNameE ?? request.empName);
    final vacationType = isArabic ? request.vacationTypeString : (request.vacationTypeStringE ?? request.vacationTypeString);
    final locale = localeProvider.locale.toLanguageTag();

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      empName ?? l10n.vacationRequest,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.underAction,
                      style: const TextStyle(color: AppColors.accentColor, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.category_outlined, l10n.vacationTypeLabel, vacationType ?? l10n.notSpecified),
              _buildInfoRow(Icons.date_range_outlined, l10n.from, '${_formatDate(request.startDt, locale)}   ${l10n.to}   ${_formatDate(request.endDt, locale)}'),
              _buildInfoRow(Icons.timer_outlined, l10n.durationLabel, '${request.period?.toString() ?? '0'} ${l10n.daysUnit}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textColor.withOpacity(0.6), size: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textColor, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: AppColors.textColor.withOpacity(0.8)),
            ),
          ),
        ],
      ),
    );
  }
}
