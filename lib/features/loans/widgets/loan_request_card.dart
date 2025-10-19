// lib/features/loans/widgets/loan_request_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/providers/hr_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/models/loan_request_model.dart';

class LoanRequestCard extends StatelessWidget {
  final LoanRequestItem request;
  final VoidCallback onTap;

  const LoanRequestCard({
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
    final locale = localeProvider.locale.toLanguageTag();

    final empName = isArabic ? request.empName : (request.empNameE ?? request.empName);
    final loanTypeName = isArabic
        ? Provider.of<HrProvider>(context, listen: false).getLoanTypeName(request.loanType ?? 0,true)
        : (Provider.of<HrProvider>(context, listen: false).getLoanTypeName(request.loanType ?? 0, false));

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
                      empName ?? l10n.loanRequest,
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
              _buildInfoRow(Icons.category_outlined, l10n.loanTypeLabel, loanTypeName),
              _buildInfoRow(Icons.date_range_outlined, l10n.requestDateLabel, _formatDate(request.reqLoanDate, locale)),
              _buildInfoRow(Icons.play_circle_outline, l10n.loanStartDateLabel, _formatDate(request.loanStartDate, locale)),
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
