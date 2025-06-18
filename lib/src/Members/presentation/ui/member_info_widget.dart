import 'package:ch_db_admin/src/Members/presentation/ui/member_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';

import '../../../../shared/utils/custom_print.dart';

class MemberInfoWidget extends StatelessWidget {
  final Member member;

  const MemberInfoWidget({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    miPrint(member.children.runtimeType);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelValue("Location:", member.location, theme),
        _buildLabelValue("Contact:", member.contact, theme),
        _buildLabelValue("Marriage Status:", member.marriageStatus, theme),
        _buildLabelValue("Spouse:", member.spouseName ?? 'N/A', theme),
        _buildLabelValue(
          "Children:",
          member.children!.isNotEmpty
              ? member.children!.length == 1 && member.children!.first.isEmpty
                  ? 'N/A'
                  : member.children!.join(',')
              : 'N/A',
          theme,
        ),
        _buildLabelValue(
            "Relative Contact:", member.relativeContact ?? 'N/A', theme),
        _buildLabelValue(
          "Date of Birth:",
          member.dateOfBirth.toLocal().toIso8601String().split('T')[0],
          theme,
        ),
        _buildLabelValue(
          "Group Affiliates:",
          member.groupAffiliate!.isNotEmpty
              ? member.groupAffiliate!.join(', ')
              : 'N/A',
          theme,
        ),
        _buildLabelValue("Role:", member.role!, theme),
      ],
    );
  }

  Widget _buildLabelValue(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: "$label ",
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: value,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
