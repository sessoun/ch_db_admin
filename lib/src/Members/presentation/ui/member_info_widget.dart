import 'package:flutter/material.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';

class MemberInfoWidget extends StatelessWidget {
  final Member member;

  const MemberInfoWidget({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print(member.children);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelValue("Location:", member.location, theme),
        _buildLabelValue("Contact:", member.contact, theme),
        _buildLabelValue("Marriage Status:", member.marriageStatus, theme),
        _buildLabelValue("Spouse:", member.spouseName!, theme),
        _buildLabelValue(
          "Children:",
          member.children!.isNotEmpty ? member.children!.join(', ') : 'N/A',
          theme,
        ),
        _buildLabelValue("Relative Contact:", member.relativeContact!, theme),
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
